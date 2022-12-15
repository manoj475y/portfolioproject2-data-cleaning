use portfolio_project;


-- breaking out propertyaddress into individual columns(address, city, state)


select substring(propertyaddress,1, locate(',', propertyaddress)-1) address,
substring(propertyaddress, locate(',', propertyaddress)+1, length(propertyaddress)) address
from nashvillehousing;

alter table nashvillehousing
add column propertysplitaddress varchar(255);

update nashvillehousing
set propertysplitaddress = substring(propertyaddress, 1,locate(',', propertyaddress)-1);

alter table nashvillehousing
add column propertysplitcity varchar(255);

update nashvillehousing
set propertysplitcity = substring(propertyaddress, locate(',', propertyaddress)+1, length(propertyaddress));

-- breaking out owner address into individual coloumns(address, city,state)


select owneraddress, substring_index(owneraddress, ',', 1) address,
substring_index(substring_index(owneraddress,',',2), ',', -1) address,
substring_index(owneraddress, ',', -1) address
from nashvillehousing;

alter table nashvillehousing
add column ownersplitaddress varchar(255);

update nashvillehousing
set ownersplitaddress = substring_index(owneraddress, ',', 1);

alter table nashvillehousing
add column ownersplitcity varchar(255);

update nashvillehousing
set ownersplitcity = substring_index(substring_index(owneraddress,',',2), ',', -1);

alter table nashvillehousing
add column ownersplitstate varchar(255);

update nashvillehousing
set ownersplitstate = substring_index(owneraddress, ',', -1);

-- change Y and N to Yes and No in 'sold as vacant' field

select distinct soldasvacant, count(soldasvacant) from nashvillehousing
group by soldasvacant;

update nashvillehousing
set soldasvacant = 'Yes' where soldasvacant = 'Y';

update nashvillehousing
set soldasvacant = 'NO' where soldasvacant = 'N';

-- REMOVE DUPLICATES

with rownumcte as (

select *, row_number() over(partition by parcelid, propertyaddress, saleprice,
saledate, legalreference order by  uniqueid) row_num 
from nashvillehousing 
)
delete from rownumcte where row_num > 1;

-- delete unused columns


alter table nashvillehousing
drop column propertyaddress;

alter table nashvillehousing
drop column owneraddress;

alter table nashvillehousing
drop column taxdistrict;

select * from nashvillehousing;










 




