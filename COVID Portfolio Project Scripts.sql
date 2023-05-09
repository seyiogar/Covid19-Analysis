SELECT *
FROM CovidDeaths
order by 3,4

SELECT *
FROM CovidVaccinations
order by 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE location like '%states%'
order by location, date


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
where location like 'Nigeri%'
order by location, date


SELECT location, population, MAX(total_cases) AS HighestInfectionCount ,  MAX((total_cases/population)*100) as PercentagePopulationInfected
FROM CovidDeaths
GROUP BY location, population
order by PercentagePopulationInfected DESC


SELECT location, population, MAX(total_deaths) AS TotalDeathCount 
FROM CovidDeaths
WHERE continent is not null
GROUP BY location, population
order by TotalDeathCount DESC


SELECT continent, MAX(total_deaths) AS TotalDeathCount 
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
order by TotalDeathCount DESC


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollingPeopleVaccinated
from CovidDeaths as dea
join CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollingPeopleVaccinated
from CovidDeaths as dea
join CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100 as PercentagePeopleVaccinated
from PopvsVac
order by 2,3


Create view PercentPopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths as dea
join CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT *
FROM PercentPopulationvaccinated
