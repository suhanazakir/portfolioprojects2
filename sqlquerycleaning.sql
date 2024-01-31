--cleaning data by sqlqueries


select * from portdolioprojectonsql.dbo.nashvillehousing 

--standardizing date format

select SaleDate,CONVERT(date,SaleDate) from  portdolioprojectonsql.dbo.nashvillehousing

USE portdolioprojectonsql
ALTER TABLE nashvillehousing 
ADD SalesDateConverted date;
update nashvillehousing 
set SaleDateConverted = CONVERT(date,SaleDate)
select SaleDateConverted, CONVERT(date,SaleDate)  from portdolioprojectonsql.dbo.nashvillehousing





--populate property address data

select * from portdolioprojectonsql.dbo.nashvillehousing
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) from 
portdolioprojectonsql.dbo.nashvillehousing a
JOIN portdolioprojectonsql.dbo.nashvillehousing b
on a.ParcelID =b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) from 
portdolioprojectonsql.dbo.nashvillehousing a
JOIN portdolioprojectonsql.dbo.nashvillehousing b
on a.ParcelID =b.ParcelID
AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out address into indiviual column(address,city,state)

select PropertyAddress from portdolioprojectonsql.dbo.nashvillehousing 

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress ) -1 ) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress ) +1 , LEN(PropertyAddress)) as Address
from portdolioprojectonsql.dbo.nashvillehousing 

use portdolioprojectonsql
ALTER TABLE nashvillehousing 
ADD propertysplitaddress Nvarchar(255);

update nashvillehousing 
set propertysplitaddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress ) -1 )



ALTER TABLE nashvillehousing 
ADD propertysplitcity Nvarchar(255)

update nashvillehousing 
set propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress ) +1 , LEN(PropertyAddress))


select * from portdolioprojectonsql.dbo.nashvillehousing



select OwnerAddress from portdolioprojectonsql.dbo.nashvillehousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3 )
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2 )
 ,PARSENAME(REPLACE(OwnerAddress, ',' ,'.'),1 )
from portdolioprojectonsql.dbo.nashvillehousing
use portdolioprojectonsql
ALTER TABLE nashvillehousing 
ADD OwnerSplitAddress Nvarchar(255)

update nashvillehousing 
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3 )

ALTER TABLE nashvillehousing 
ADD OwnerSplitCity Nvarchar(255)

update nashvillehousing 
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2 )

ALTER TABLE nashvillehousing 
ADD OwnerSplitstate Nvarchar(255)

update nashvillehousing 
set OwnerSplitstate  = PARSENAME(REPLACE(OwnerAddress, ',' ,'.'),1 )


select * from portdolioprojectonsql.dbo.nashvillehousing

----change Y and N to yes and no in sold as vacant

select distinct SoldAsVacant, count(SoldAsVacant)
from portdolioprojectonsql.dbo.nashvillehousing
group by SoldAsVacant
order by 2



select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'yes'
     when SoldAsVacant = 'N' then 'no'
	 else  SoldAsVacant
	 end
from portdolioprojectonsql.dbo.nashvillehousing

USE portdolioprojectonsql

update nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'yes'
     when SoldAsVacant = 'N' then 'no'
	 else  SoldAsVacant
	 end

--remove duplicates


with RowNumCTE as
(
select *, 
ROW_NUMBER()over (
partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			 UniqueID
			 )row_num
			 
from portdolioprojectonsql.dbo.nashvillehousing 
)

select *  from RowNumCTE
where row_num>1

--delete columns

select * from portdolioprojectonsql.dbo.nashvillehousing

ALTER TABLE portdolioprojectonsql.dbo.nashvillehousing
DROP COLUMN OwnerAddress, PropertyAddress,TaxDistrict

ALTER TABLE portdolioprojectonsql.dbo.nashvillehousing
DROP COLUMN SaleDate




