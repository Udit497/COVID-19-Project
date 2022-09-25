----------------------------------WROTE THESE QUERIES IN MICROSOFT SQL SERVER---------------------------------

--Looking at the whole content ordering by parcel ID
select * from NashvilleHousing
--where PropertyAddress is null
order by ParcelID;

-- Populate property address where it is NULL

select * from NashvilleHousing                    --Problem
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,      --Query
isnull(a.PropertyAddress, b.PropertyAddress)         
from NashvilleHousing a inner join
NashvilleHousing b on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
--where a.PropertyAddress is null;

Update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a inner join
NashvilleHousing b on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

--Standardize date format

select SaleDate from NashvilleHousing   --Problem

Alter table NashvilleHousing    --Query 
Add saleDateConverted date;


update NashvilleHousing
set saleDateConverted = convert(date, SaleDate) 

select saleDateConverted  -- Veiwing the changes
from NashvilleHousing 

alter table NashvilleHousing        -- Removing the old date table
drop column SaleDate

select * from NashvilleHousing    -- Veiwing the changes

-- Breaking out PropertyAddress into Individual Columns (Address, State)


ALTER TABLE NashvilleHousing
Add PropertyAddressNew Nvarchar(255);

Update NashvilleHousing
SET PropertyAddressNew = PARSENAME(REPLACE(PropertyAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add PropertyState Nvarchar(255);

Update NashvilleHousing
SET PropertyState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvilleHousing    -- Viewing the changes 


-- -- Breaking out OwnerAddress into Individual Columns (Address, City, State)

ALTER TABLE NashvilleHousing
add OwnerAddressSplit Nvarchar(255);

Update NashvilleHousing
SET OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From PortfolioProject.dbo.NashvilleHousing     -- Viewing the change


--Change Y and N to Yes and No in SoldAsVacant :

Select Distinct(SoldAsVacant) from NashvilleHousing    -- Problem

Update NashvilleHousing                                    -- Query
set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant 
	   END

select distinct(SoldAsVacant) from NashvilleHousing       -- Viewing the changes 
	   
-- Removing duplicate Rows:

with RowNum as 
 (select *, ROW_NUMBER() Over(                            --Problem 
		Partition by ParcelID, 
					 PropertyAddress,
					 SalePrice,
					 LegalReference,
					 OwnerAddress
		Order by UniqueID) row_num
From NashvilleHousing 
) select * from RowNum where row_num > 1	


with RowNum as 
 (select *, ROW_NUMBER() Over(                            -- Query 
		Partition by ParcelID, 
					 PropertyAddress,
					 SalePrice,
					 LegalReference,
					 OwnerAddress
		Order by UniqueID) row_num
From NashvilleHousing 
) Delete from RowNum where row_num > 1	


--------------------------------------------------------------------------