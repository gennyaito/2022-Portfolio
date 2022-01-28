---cleaning data with sql queries

select *
from Portfolio..[Nashville housing]


--standardize date format

select SaleDateConverted, CONVERT(Date,SaleDate)
from Portfolio..[Nashville housing]

UPDATE Portfolio..[Nashville housing]
Set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Portfolio..[Nashville housing]
add SaleDateConverted Date;

UPDATE Portfolio..[Nashville housing]  --- second step
Set SaleDateConverted = CONVERT(Date,SaleDate)


--- Populate property address data

select *
from Portfolio..[Nashville housing]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolio..[Nashville housing] a
JOIN Portfolio..[Nashville housing] b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null

 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 from Portfolio..[Nashville housing] a
 JOIN Portfolio..[Nashville housing] b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null



 --Breaking out address into individual columns (Address, City, State)

 select PropertyAddress
from Portfolio..[Nashville housing]

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1 ) as Address

from Portfolio..[Nashville housing]



SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from Portfolio..[Nashville housing]


ALTER TABLE Portfolio..[Nashville housing]
add PropertySplitAdress nvarchar(255);

UPDATE Portfolio..[Nashville housing]  --- second step
Set PropertySplitAdress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1 ) 


ALTER TABLE Portfolio..[Nashville housing]
add PropertySplitCity nvarchar(255);

UPDATE Portfolio..[Nashville housing]  --- second step
Set PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) 


Select *
from Portfolio..[Nashville housing]



Select OwnerAddress
from Portfolio..[Nashville housing]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from Portfolio..[Nashville housing]
where OwnerAddress is not null

ALTER TABLE Portfolio..[Nashville housing]
add OwnerSplitAdress nvarchar(255);

UPDATE Portfolio..[Nashville housing]  --- second step
Set OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE Portfolio..[Nashville housing]
add OwnerSplitCity nvarchar(255);

UPDATE Portfolio..[Nashville housing]  --- second step
Set OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE Portfolio..[Nashville housing]
add OwnerSplitTown nvarchar(255);

UPDATE Portfolio..[Nashville housing]  --- second step
Set OwnerSplitTown  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select *
from Portfolio..[Nashville housing]
Order by  ParcelID





--Change Y and N to Yes and No in 'Sold as Vacant' field

Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from Portfolio..[Nashville housing]
group by SoldAsVacant
order by 2


SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N'THEN 'NO'
	   ELSE SoldAsVacant
	   END
from Portfolio..[Nashville housing]

Update [Nashville housing]
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N'THEN 'NO'
	   ELSE SoldAsVacant
	   END
from Portfolio..[Nashville housing]




--Remove Duplicates
WITH RowNumCTE AS(
Select *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				 UniqueID
				 ) row_num

from Portfolio..[Nashville housing]
--order by ParcelID
)
SELECT *
from RowNumCTE
where row_num > 1
--order by PropertyAddress

--DELETE
--from RowNumCTE
--where row_num > 1




--Delete Unused Columns


SELECT *
from Portfolio..[Nashville housing]
Order by ParcelID


ALTER TABLE Portfolio..[Nashville housing]
DROP COLUMN OwnerSplitState, OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio..[Nashville housing]
DROP COLUMN SaleDate










