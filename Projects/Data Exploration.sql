->

SELECT * FROM coviddeaths
WHERE continent is NOT null
ORDER BY 3,4

SELECT * FROM covidvaccinations
WHERE continent is NOT null
ORDER BY 3,4

->select the data that going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From coviddeaths
Where continent is not null 
order by 1,2

->total cases vs total deaths(in country)

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where location like '%indonesia%'
AND continent is NOT null
order by 1,2

->total cases vs population
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
where continent is NOT null
order by 1,2

->country with highest infections

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

->total highest deaths per country(total cases is varchar need to be convert to int)

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE continent is not null
Group by Location
order by TotalDeathCount DESC


->total highest deaths per continent(total cases is varchar need to be convert to int)

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
WHERE continent is not null
Group by continent
order by TotalDeathCount DESC

->global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2

->total populations vs vaccinations(using cte)

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select coviddeaths.continent, coviddeaths.location, coviddeaths.date, coviddeaths.population, covidvaccinations.new_vaccinations
, SUM(CONVERT(int,covidvaccinations.new_vaccinations)) OVER (Partition by coviddeaths.Location Order by coviddeaths.location, coviddeaths.Date) as RollingPeopleVaccinated
From coviddeaths
Join covidvaccinations
	On coviddeaths.location = covidvaccinations.location
	and coviddeaths.date = covidvaccinations.date
where coviddeaths.continent is not null )
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
