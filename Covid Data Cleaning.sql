--Skills : GROUP BY, CAST, OVER(), CREATE VIEW, AGGREGATE FUNCTION
--Check the dataset--
SELECT *
FROM CovidDeaths
ORDER BY 3,4;

SELECT *
FROM CovidVaccinations
ORDER BY 3,4;

--Step 1
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

--Question 1-- What is the probability of dying in the United Kingdom if you contacted covid?

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Percentage_of_death_to_cases
FROM CovidDeaths
WHERE location LIKE 'U%M'
ORDER BY date

--Question 2 --What is the percentage of the population contracted covid in the United Kingdom?

SELECT location, date, total_cases, population, total_cases/population *100 AS Pecentage_of_Population_infected
FROM CovidDeaths
WHERE location LIKE 'U%M'
ORDER BY date

--Question 3 --Country with highest infection rate
CREATE VIEW highest_infection_rate
AS
SELECT location, MAX(total_cases) AS high_cases, population, MAX((total_cases/population)) *100 AS infection_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY LOCATION, POPULATION
--ORDER BY infection_rate DESC

--Question 4 -- Countries with highest death rate 
SELECT location,  total_cases, MAX(total_deaths) AS high_death, MAX((total_deaths/total_cases)) *100 AS death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, total_cases
ORDER BY death_rate DESC

--Question 5-- Countries with highest death per population
CREATE VIEW death_per_population
AS
SELECT location,  population, MAX(total_deaths) AS high_death, MAX((total_deaths/population)) *100 AS death_rate_population
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
--ORDER BY death_rate_population DESC

--Question 6 --Countries with the highest death count (Here we casted total_deaths as int because the data type is NVARCHAR)
SELECT location, MAX(cast(total_deaths AS INT)) AS death 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death DESC

==Question 7 --Continent with the highest death count
SELECT location, MAX(cast(total_deaths AS INT)) AS death 
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY death DESC

CREATE VIEW Continent_with_highest_death_count
AS
SELECT continent, MAX(cast(total_deaths AS INT)) AS death 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
--ORDER BY death DESC

--Question 8 Total new cases in the world 
SELECT date, SUM(new_cases) AS new_cases, SUM(CAST(new_deaths AS int)) AS new_deaths, 
SUM(CAST(new_deaths AS int))/SUM(new_cases) * 100 AS percentage_of_newdeaths_to_newcases
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date ASC

--Question 9 ---Cumulative new vaccinations 
CREATE VIEW Cumulative_new_Vaccination
AS
SELECT cd.continent, cd.location, cd.date,  cd.population, cv.new_vaccinations,
SUM(Convert(int, cv.new_vaccinations)) OVER(Partition by cd.location order by cd.location,cd.date) AS Cumulative_new_vaccinations
FROM CovidDeaths cd
JOIN CovidVaccinations cv
ON cd.location= cv.location
AND cd.date=cv.date
WHERE cd.continent IS NOT NULL

--Queston 10 -- Create Views for visualization
--For this question, I went back to all queries I created and added the create view statements
