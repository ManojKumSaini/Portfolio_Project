-- Update Date 

Select Convert(date, SaleDate)
From NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(date, SaleDate)


-- Second Option
Alter table NashvilleHousing
Add SalesDate Date;

Update NashvilleHousing
Set SalesDate = Convert(date, SaleDate)

Select SalesDate
From NashvilleHousing

-- Populate Property Adress

Select a.ParcelID ,a.PropertyAddress, b.ParcelID, b.PropertyAddress
From NashvilleHousing a
join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = b.PropertyAddress
From NashvilleHousing a
join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-- Another Method 

Select a.ParcelID ,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking adress in 2 columns

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as 'Adress',
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as 'Locatioin'
From NashvilleHousing 

Alter Table NashvilleHousing
Add Propertyhome_adress Nvarchar(255);

Update NashvilleHousing
Set Propertyhome_adress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


Alter Table NashvilleHousing
Add Propertyhome_city Nvarchar(255);

Update NashvilleHousing
Set Propertyhome_city = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select OwnerAddress,
PARSENAME(Replace(OwnerAddress,',','.'),3) as Adress,
PARSENAME(Replace(OwnerAddress,',','.'),2) as City,
PARSENAME(Replace(OwnerAddress,',','.'),1) as State
From NashvilleHousing

Alter Table NashvilleHousing
Add Ownersplitadress nvarchar(255);

Alter Table NashvilleHousing
Add Ownercity nvarchar(255);

Alter Table NashvilleHousing
Add Ownerstate nvarchar(255);

Update NashvilleHousing
Set Ownersplitadress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Update NashvilleHousing
Set Ownercity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Update NashvilleHousing
Set  Ownerstate = PARSENAME(Replace(OwnerAddress,',','.'),1)


-- Convert "Y" and "N" to "Yes" and "No" in SoldasVacant

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
     when SoldAsVacant = 'N' Then 'No'
     Else SoldAsVacant
End
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
                        when SoldAsVacant = 'N' Then 'No'
                        Else SoldAsVacant
						End

Select SoldAsVacant,
COUNt(SoldAsVacant) as Counts
From NashvilleHousing
Group by SoldAsVacant

-- Delete Unused Columns


Alter TABLE NashvilleHousing
Drop Column SaleDate, 
     OwnerAddress,
	 TaxDistrict,
	 PropertyAddress
