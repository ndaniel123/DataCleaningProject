
select *
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject

-- Standardize Date Format

Select SaleDateConverted, CONVERT(date,SaleDate)
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject


update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set SaleDate = CONVERT(Date,SaleDate)


Alter Table [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
Add SaleDateConverted Date;

update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address

Select *
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject a
join [PORTFOLIO PROJECT].dbo.NashvilleHousingProject b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
set propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject a
join [PORTFOLIO PROJECT].dbo.NashvilleHousingProject b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
--Where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject


Alter Table [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
Add PropertySplitAddress Nvarchar(255);

update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
Add PropertySplitCity Nvarchar(255);

update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


select *
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject



select OwnerAddress
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject


select
PARSENAME(replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(replace(OwnerAddress, ',', '.') ,1)
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject


Alter Table [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
Add OwnerSplitAddress Nvarchar(255);

update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') ,3)

Alter Table [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
Add OwnerSplitCity Nvarchar(255);

update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') ,2)

Alter Table [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
Add OwnerSplitState Nvarchar(255);

update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)


select *
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject



-- Change Y and N to Yes and No ins "Sold as Vacant" Field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject


update [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
set SoldAsVacant =  CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

with RowNumCTE as(
Select *,
	ROW_NUMBER() over (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num


from [PORTFOLIO PROJECT].dbo.NashvilleHousingProject
--order by ParcelID
)
Select *
from RowNumCTE
where row_num > 1 
--order by PropertyAddress


-- Delete Unused Columns


Select *
From [PORTFOLIO PROJECT].dbo.NashvilleHousingProject

ALTER TABLE[PORTFOLIO PROJECT].dbo.NashvilleHousingProject
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE[PORTFOLIO PROJECT].dbo.NashvilleHousingProject
DROP COLUMN SaleDate