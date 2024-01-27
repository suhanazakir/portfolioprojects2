Select * from portdolioprojectonsql.dbo.CovidDeaths$
order by 3,4

Select * from portdolioprojectonsql.dbo.CovidVaccinations$
order by 3,4

--select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from portdolioprojectonsql.dbo.CovidDeaths$ 
order by 1,2

--looking at total cases vs total death
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portdolioprojectonsql.dbo.CovidDeaths$ 
order by 1,2

--show likelihood of dying if you are in your country US
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portdolioprojectonsql.dbo.CovidDeaths$ 
where location like '%states%' 
order by 1,2

--looking at total cases vs population
--shows percentage of population to get covid

Select location, date, population, total_cases, (total_cases/population)*100 as Percentofpopulationaffected
from portdolioprojectonsql.dbo.CovidDeaths$ 
where location like '%states%'
order by 1,2


--looking at countries with highest infection rate compared to population
Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as percentofpopulationaffected
from portdolioprojectonsql..CovidDeaths$ 
group by location, population
order by percentofpopulationaffected desc

--showing countries with highest death count per population
Select location, MAX(cast(total_deaths as int)) as totaldeathcount
from portdolioprojectonsql..CovidDeaths$ 
where continent IS NOT NULL
group by location
order by totaldeathcount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

--showing continents with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as totaldeathcount
from portdolioprojectonsql..CovidDeaths$ 
where continent is not null
group by continent
order by totaldeathcount desc

--global numbers
Select Sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from portdolioprojectonsql.dbo.CovidDeaths$ 
where continent is not null
order by 1,2

--looking at total population vs vaccination
Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) 
as rollingpeoplevaccinated
 from portdolioprojectonsql.dbo.CovidDeaths$ dea
join portdolioprojectonsql.dbo.CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

--USE CTE

with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
 Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) 
as rollingpeoplevaccinated
 from portdolioprojectonsql.dbo.CovidDeaths$ dea
join portdolioprojectonsql.dbo.CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 )
 select * ,(rollingpeoplevaccinated/population)*100
 from popvsvac




 --use temp table
drop table if exists #percentpopulationvaccinated
 create table #percentpopulationvaccinated(continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric, 
 new_vaccinations numeric,
 rollingpeoplevaccinated numeric
 )
 insert into #percentpopulationvaccinated
 Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) 
as rollingpeoplevaccinated
 from portdolioprojectonsql.dbo.CovidDeaths$ dea
join portdolioprojectonsql.dbo.CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 

 select * ,(rollingpeoplevaccinated/population)*100
 from  #percentpopulationvaccinated

 
 --creating view to store data for later visualization

create view percentpopulationvaccinated as
Select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) 
as rollingpeoplevaccinated
 from portdolioprojectonsql.dbo.CovidDeaths$ dea
join portdolioprojectonsql.dbo.CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null

