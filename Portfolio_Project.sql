--Select *
--From CovidDeaths
--order by 3,4

--select *
--From CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1, 2 desc

-- Death Percentage in India
Select Location, date, total_cases, total_deaths ,(cast(total_deaths as numeric)/ cast(total_cases as numeric))*100 as 'Deathpercentage'
From CovidDeaths
where Location = 'India'
order by 2


-- Infected Population in India

Select Location, date, population, total_cases, (total_cases/population)*100 as 'Infected Population'
From CovidDeaths
where Location = 'India'
order by 2

--Highest infected countries in context of Population

Select Location, population,Max(cast(total_cases as numeric)) as Highest_Cases, Max((total_cases/population))*100 as 'Infected Population'
From CovidDeaths
Group by Location, population
Order by 4 desc

-- Highest Death Count in World

Select Location, MAX(cast(total_deaths as numeric)) as Highest_Death
From CovidDeaths
Where continent is Not Null
Group by location
Order by 2 Desc

-- Highest Death Count by Continent

Select continent, MAX(cast(total_deaths as numeric)) as Highest_Death
From CovidDeaths
Where continent is not null
Group by continent
Order by 2 Desc

--Highest Death Percent per population around the world

Select Location, population,Max(cast(total_deaths as numeric)) as Highest_Deaths, Max((total_deaths/population))*100 as 'Death Percent'
From CovidDeaths
Where continent is Not Null
Group by Location, population
Order by 4 desc

--Highest Death Percent per population in Asia

Select Location, population,Max(cast(total_deaths as numeric)) as Highest_Deaths, Max((total_deaths/population))*100 as 'Death Percent'
From CovidDeaths
Where continent = 'Asia'
Group by Location, population
Order by 4 desc

-- New cases and Total Deaths around the World by date

Select date, Sum(new_cases)as New_Cases, SUM(cast(total_deaths as numeric)) as Deaths
From CovidDeaths
where continent is not null
Group by date
order by 1

-- Total Cases vs Total Deaths around the world by date

Select date, Sum(cast(total_cases as numeric))as Total_cases, SUM(cast(total_deaths as numeric)) as Deaths, (SUM(cast(total_deaths as int))/SUM(CAST(total_cases as numeric)))*100 as Death_Perecentage
From CovidDeaths
where continent is not null
Group by date
order by 1

-- Total cases vs Total Deaths 

Select Sum(cast(total_cases as numeric))as Total_cases, SUM(cast(total_deaths as numeric)) as Deaths, (SUM(cast(total_deaths as numeric))/SUM(CAST(total_cases as numeric)))*100 as Death_Perecentage
From CovidDeaths
where continent is not null

-- Highest Death count by Date

Select date, SUM(cast(total_deaths as numeric)) as Highest_Death
From CovidDeaths
where continent is null
Group by date,total_deaths
order by 2 desc

-- Highest Death count by Date and Death

Select date, SUM(cast(total_deaths as numeric))
From CovidDeaths
where continent is not null
Group by date,total_deaths
order by 1,2 desc


-- Total Population vs New Vaccination

Select de.continent,de.location, de.date, de.population, vac.new_vaccinations
,SUM(convert(numeric,vac.new_vaccinations)) over (partition by de.location order by de.Date , de.Location)
From  CovidVaccinations vac
join CovidDeaths de
on vac.location = de.location
and vac.date= de.date
where de.continent is not null
order by 2,3


-- CTE

With POPvsVAC (continent,location, date, population, new_vaccinations, PopulationVaccinated)
as(

Select de.continent,de.location, de.date, de.population, vac.new_vaccinations
,SUM(convert(numeric,vac.new_vaccinations)) over (partition by de.location order by de.Date , de.Location)
as PoulationVaccinated
From  CovidVaccinations vac
join CovidDeaths de
on vac.location = de.location
and vac.date= de.date
where de.continent is not null
)

SElect *, (PopulationVaccinated/population)*100
From  POPvsVAC
WHERE location = 'India'

-- Temp Table

--Drop table if exists #Population_Vaccinated
Create Table #Population_Vaccinated(
continent varchar(255)
,Location varchar(255)
,date datetime
,population numeric
,new_vaccination numeric,
PoulationVaccinated numeric)

Insert into #Population_Vaccinated

Select de.continent,de.location, de.date, de.population, vac.new_vaccinations
,SUM(convert(numeric,vac.new_vaccinations)) over (partition by de.location order by de.Date , de.Location)
as PoulationVaccinated
From  CovidVaccinations vac
join CovidDeaths de
on vac.location = de.location
and vac.date= de.date

Select Location, MAX(PoulationVaccinated) as Highest_Vaccinated_Places
From #Population_Vaccinated
Group by Location
Order by 2 desc


Create view Population_Vaccinated as 
Select de.continent,de.location, de.date, de.population, vac.new_vaccinations
,SUM(convert(numeric,vac.new_vaccinations)) over (partition by de.location order by de.Date , de.Location)
as PoulationVaccinated
From  CovidVaccinations vac
join CovidDeaths de
on vac.location = de.location
and vac.date= de.date