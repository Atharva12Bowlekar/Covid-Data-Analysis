select *
from CovidDeaths
order by 3,4;

select * 
from CovidVaccinations
order by 3,4;

-- Select Data We are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2;

-- Looking at total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
Where location = 'India'
order by 1,2;

-- Looking at total cases vs population

select location, date, total_cases, population, (total_cases/population)*100 as PercentageInfectedPopulation
from CovidDeaths
Where location = 'India'
order by 1,2;

-- Countries with Highest Infected Rates Tableau 3

select location, max(total_cases) as HighestInfected, population, max(total_cases/population)*100 as PercentageInfectedPopulation
from CovidDeaths
--Where location = 'India'
group by location, population
order by 4 desc;

-- Countries with the highest death count

select location, max(cast(total_deaths as int)) as totaldeath
from CovidDeaths
where continent is not null
group by location
order by 2 desc;

-- Continents with Highest Infected Rates

select location, max(cast(total_deaths as int)) as HighestDeathRate
from CovidDeaths
where continent is null 
group by location
order by 2 desc;

-- Tableau 2 

select continent, max(cast(total_deaths as int)) as HighestDeathRate
from CovidDeaths
where continent is not null 
group by continent
order by 2 desc;

-- New cases by date

select date, sum(new_cases) as NewCases, sum(cast(new_deaths as int)) as NewDeaths, sum(cast(new_deaths as int))/sum(new_cases)
as NewDeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1;


-- Total Tableau 1
select sum(new_cases) as Cases, sum(cast(new_deaths as int)) as Casualties, sum(cast(new_deaths as int))/sum(new_cases)*100 as 
CasualtiesPercentage
from CovidDeaths
where continent is not null;

-- Looking at total population vs vaccinations

select dea.continent, dea.date, dea.location, population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.date) as VaccinatedPeople
from CovidDeaths as dea 
join CovidVaccinations as vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 3,2

-- Total Vaccinations By Each Country
select dea.location, sum(cast(vac.new_vaccinations as int))
--sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location)
from CovidDeaths as dea
join CovidVaccinations as vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
group by dea.location
order by 1


-- CTE

with cte_pop_vac (Continent, Date, Location, Population, New_Vaccination, Vaccinated_People) 
as
(
select dea.continent, dea.date, dea.location, population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.date) as VaccinatedPeople
from CovidDeaths as dea 
join CovidVaccinations as vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 3,2
)
Select *, (Vaccinated_People/Population) * 100 as VaccinatedPercentage
from cte_pop_vac
order by 3,2


-- Temp Table

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Date datetime,
Location nvarchar(255),
Population numeric,
NewVaccinations numeric,
VaccinatedPeople numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.date, dea.location, population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.date) as VaccinatedPeople
from CovidDeaths as dea 
join CovidVaccinations as vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (VaccinatedPeople/Population) * 100 as VaccinatedPercentage
from #PercentPopulationVaccinated
order by 3,2

-- Creating a view

Create view PercentPopulationVaccinated as
select dea.continent, dea.date, dea.location, population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.date) as VaccinatedPeople
from CovidDeaths as dea 
join CovidVaccinations as vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select * 
from PercentPopulationVaccinated


-- Tableau 4
select location, date, population, Max(total_cases)/population*100 as InfectedPopulationPercent
from CovidDeaths
where continent is not null
group by location, date, population
order by InfectedPopulationPercent desc;
















