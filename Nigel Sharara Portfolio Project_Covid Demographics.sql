Select *
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
Where continent is not null
Order by 3,4

--Select *
--From [Covid Demographics].dbo.['Nigel Portfolio Project2- Vaccx$'] 
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
order by 1,2

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as PercentDeath
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
Where Location like '%South Africa%'
order by 1,2

Select Location, total_cases, total_deaths,(total_deaths/total_cases)*100 as PercentDeath
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
Where Location like '%South Africa%'
order by 1,2

Select Location, date, population, total_deaths,(total_deaths/population)*100 as PercentDeath
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
Where Location like '%South Africa%'
order by 1,2

Select Location, date, population, total_cases,(total_cases/population)*100 as PercentCases
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
Where Location like '%South Africa%'
order by 1,2

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentCases
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
--Where Location like '%South Africa%'
Group by Location, population
order by PercentCases desc

Select Location, population, Max(total_deaths) as TotalDeathCount, Max((total_deaths/population))*100 as PercentDeaths
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
--Where Location like '%South Africa%'
Group by Location, population
order by PercentDeaths desc

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
--Where Location like '%South Africa%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

Select Continent, Max(cast(total_deaths as int)) as TotalDeathCount
From [Covid Demographics].dbo.['Nigel Portfolio Project1$']
--Where Location like '%South Africa%'
Where continent is not null
Group by Continent
order by TotalDeathCount desc

--Use CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, SuccessiveVaccinations)
as (
Select de.continent, de.location, de.date, de.population, vax.new_vaccinations
, SUM(cast(vax.new_vaccinations as bigint)) OVER (partition by de.location Order by de.location, de.date)
--, SuccessiveVaccinations/population)*100
from [Covid Demographics].dbo.['Nigel Portfolio Project1$'] de
join [Covid Demographics].dbo.['Nigel Portfolio Project2- Vaccx$'] vax
On de.location = Vax.location
and de.date = Vax.date
where de.continent is not null
--order by 2,3
)
Select *, (SuccessiveVaccinations/Population)*100 as SuccessivePercentageVaccinations
from PopvsVac

--TEMP TABLE
Drop table if exists #SuccessivePercentageVaccinations
Create Table #SuccessivePercentageVaccinations
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
SuccessiveVaccinations numeric
)
insert into #SuccessivePercentageVaccinations
Select de.continent, de.location, de.date, de.population, vax.new_vaccinations
, SUM(cast(vax.new_vaccinations as bigint)) OVER (partition by de.location Order by de.location, de.date) 
--, SuccessiveVaccinations/population)*100
from [Covid Demographics].dbo.['Nigel Portfolio Project1$'] de
join [Covid Demographics].dbo.['Nigel Portfolio Project2- Vaccx$'] vax
On de.location = Vax.location
and de.date = Vax.date
--where de.continent is not null
--order by 2,3


Select *, (SuccessiveVaccinations/Population)*100
from #SuccessivePercentageVaccinations

Create View SuccessivePercentageVaccinations as
Select de.continent, de.location, de.date, de.population, vax.new_vaccinations
, SUM(cast(vax.new_vaccinations as bigint)) OVER (partition by de.location Order by de.location, de.date) as SuccessiveVaccinations
--, SuccessiveVaccinations/population)*100
from [Covid Demographics].dbo.['Nigel Portfolio Project1$'] de
join [Covid Demographics].dbo.['Nigel Portfolio Project2- Vaccx$'] vax
On de.location = Vax.location
and de.date = Vax.date
where de.continent is not null
--order by 2,3

Select *
from SuccessivePercentageVaccinations