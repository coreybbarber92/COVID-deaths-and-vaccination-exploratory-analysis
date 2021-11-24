--  Country population, COVID case and COVID deaths. Data was taken up until 11/14/2021

SELECT 
	Location, date, total_cases, new_cases, total_deaths, population
FROM
	PortfolioProject..CovidDeaths
WHERE
	continent is not null
ORDER BY 
	1, 2


-- Looking at total cases vs total deaths
-- likelihood of death from covid in the United States

SELECT 
	Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM
	PortfolioProject..CovidDeaths
WHERE location = 'United States'
ORDER BY 
	1, 2

-- Looking at total cases vs total deaths
-- percentage of population that contracted covid

SELECT 
	Location, date, population, total_cases, (total_cases/population)*100 as ContractionPercentage
FROM
	PortfolioProject..CovidDeaths
ORDER BY 
	1, 2

-- Looking at countries with highest infection rate vs population 

SELECT 
	Location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Percent_Population_Infected
FROM
	PortfolioProject..CovidDeaths
WHERE
	continent is not null
GROUP BY
	Location, Population
ORDER BY 
	Percent_Population_Infected DESC

-- Total deaths due to COVID per country

SELECT 
	Location, MAX(cast(total_deaths as int)) as Total_Death_Count
FROM
	PortfolioProject..CovidDeaths
WHERE
	continent is not null
GROUP BY
	Location
ORDER BY 
	Total_Death_Count DESC

-- death count per continent 

SELECT 
	Location, MAX(cast(total_deaths as int)) as Total_Death_Count
FROM
	PortfolioProject..CovidDeaths
WHERE
	location <> 'Upper middle income' AND
	location <> 'High income' AND
	location <> 'Low income' AND
	location <> 'Lower middle income' AND
	location <> 'World' AND
	location <> 'European Union' AND
	continent is null
GROUP BY
	Location
ORDER BY 
	Total_Death_Count DESC

--Global numbers daily

SELECT 
	date, SUM(new_cases) as TotalNewCases, SUM(Cast(new_deaths as int)) as TotalNewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM
	PortfolioProject..CovidDeaths
WHERE
	continent is not null
GROUP BY 
	date
ORDER BY 
	1, 2

-- Total vaccine doses over time per country 
-- Using a partition by to create a column to show the rolling number of dosages over the period of time the data was collected
-- Using a JOIN to combine columns from two data sets that give information on COVID deaths and vaccination data 

SELECT
	deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations, 
	SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by deaths.Location Order by deaths.location, deaths.date) as VaccineDoseCount
FROM
	PortfolioProject..CovidDeaths deaths
JOIN 
	PortfolioProject..CovidVaccinations vac
On 
	deaths.location = vac.location
	and deaths.date = vac.date
WHERE 
	deaths.continent is not null
ORDER BY 
	2,3

-- This data includings vaccines that require one or two doses, which leads to dosage numbers exceeding population count

-- Looking at COVID contraction rate and death percentage by economic class 

SELECT 
	Location, Population, MAX(total_cases) as TotalCases, (MAX(total_cases)/Population)*100 as PercentInfected, MAX(total_deaths) as TotalDeaths, (MAX(total_deaths)/Population)*100 as MortalityRate 
FROM
	PortfolioProject..CovidDeaths
WHERE
	location <> 'Africa' AND
	location <> 'European Union' AND
	location <> 'International' AND
	location <> 'World' AND	
	location <> 'South America' AND
	location <> 'North America' AND
	location <> 'Asia' AND
	location <> 'Oceania' AND
	location <> 'Europe' AND
	continent is null	
GROUP BY
	location, population 
ORDER BY
	location  

-- Interestingly, we find a higher infection rate and mortality rate among the higher income populations