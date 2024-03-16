--------select data that we're going to be using on 2020/01/05
SELECT continent, location, date, total_cases, new_cases, total_deaths, population
FROM proj1..CovidDeaths
where continent is not null AND date = '2020-01-05 00:00:00.000'
order by 1,2

--calculating DeathPercetage (total_deaths/total_cases)
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From proj..CovidDeaths
where continent is not null
order by 1,2

-- calculate InfectionPercentage (total_cases/population)
Select location, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as InfectionPercentage
from proj1..CovidDeaths
where continent is not null
group by location
order by InfectionPercentage DESC

-- showing continents w/ the highest death count per population
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from proj1..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount DESC

-- GLOBAL NUMBERS
Select date, SUM(cast(new_cases as int)), SUM(new_deaths), SUM(new_deaths)/SUM(NULLIF(new_cases,0))*100 
from proj1..CovidDeaths
where continent is not null
group by date
order by 1,2

--ALTER TABLE dbo.CovidDeaths
--Alter Column new_cases float;
--ALTER TABLE dbo.CovidDeaths
--Alter Column new_deaths float;

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, Nullif(sum(new_deaths), 0)/nullif(sum(new_cases), 0)*100 as DeathPercentage
from CovidDeaths
where continent is not null 
order by 1,2


ALTER TABLE dbo.CovidVaccinations
ALTER COLUMN new_vaccinations BIGINT;
-- if value larger than int max, then use bigint

-- Total Population VS Vaccinations
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

--create view to store data for later visualizations
Create view PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(convert(BIGINT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null


