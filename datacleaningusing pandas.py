#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


df = pd.read_excel(r"C:\Users\moham\Downloads\Customer Call List.xlsx")
df


# In[3]:


df = df.drop_duplicates()
df


# In[4]:


df = df.drop(columns = "Not_Useful_Column")
df


# In[6]:


df["Last_Name"] = df["Last_Name"].str.strip("123._/")
df


# In[14]:


df["Phone_Number"] = df["Phone_Number"].str.replace('[^a-zA-Z0-9]','')
df["Phone_Number"]= df["Phone_Number"].apply(lambda x: x[0:3] + '-' + x[3:6] + '-' + x[6:10])
df["Phone_Number"] = df["Phone_Number"].apply(lambda x: str(x))
df["Phone_Number"] = df["Phone_Number"].str.replace('nan--','')

df["Phone_Number"] = df["Phone_Number"].str.replace('Na--','')
df


# In[11]:





# In[15]:


df[["Street_Address", "State", "Zip_Code"]] = df["Address"].str.split(',',2, expand=True)
df


# In[27]:


df["Do_Not_Contact"] = df["Do_Not_Contact"].str.replace('Yes','Y')

df["Do_Not_Contact"] = df["Do_Not_Contact"].str.replace('No','N')
df


# In[28]:


df[["Street_Address", "State", "Zip_Code"]] = df["Address"].str.split(',',2, expand=True)
df


# In[29]:


df["Do_Not_Contact"] = df["Do_Not_Contact"].str.replace('Yes','Y')
df


# In[ ]:





# In[30]:


df.fillna('')


# In[ ]:


df["Do_Not_Contact"].str.replace('Yes','Y')
df["Paying_Customer"].str.replace('Yes','Y')


# In[36]:


df["Paying Customer"].str.replace('Yes','Y')


# In[37]:


df["Paying Customer"].str.replace('No','N')


# In[44]:





# In[46]:


for x in df.index:
    if df.loc[x,"Do_Not_Contact"] =='Y':
        df.drop(x, inplace=True)
df
        
            

        
    


# In[47]:


for x in df.index:
    if df.loc[x, "Phone_Number"] == '':
        df.drop(x, inplace=True)
df


# In[48]:


df = df.reset_index(drop=True)
df


# In[49]:


df["Paying Customer"] = df["Paying Customer"].str.replace('Yes','Y')


# In[50]:


df["Paying Customer"] = df["Paying Customer"].str.replace('No','N')


# In[52]:


df


# In[ ]:




