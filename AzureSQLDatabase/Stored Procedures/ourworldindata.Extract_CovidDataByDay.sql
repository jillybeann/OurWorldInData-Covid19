SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM [dbo].sysobjects WHERE id = OBJECT_ID(N'ourworldindata.Extract_CovidDataByDay') AND objectproperty(id,N'IsProcedure') = 1)
BEGIN
	PRINT 'Dropping Procedure ourworldindata.Extract_CovidDataByDay'
	DROP PROCEDURE ourworldindata.Extract_CovidDataByDay
END
GO

PRINT 'Creating Procedure ourworldindata.Extract_CovidDataByDay'
GO

-- =============================================
-- Author:		Jillian
-- Create date:	2021/03/26
-- Description:	Detailed COVID-19 Data by Day
-- Updates:
-- =============================================
CREATE PROCEDURE ourworldindata.Extract_CovidDataByDay (
	@StartDate DATE = NULL,
	@EndDate DATE = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- Set input variables
	IF (@StartDate IS NULL)
		SELECT @StartDate = '2020-01-01' -- Custom date
	
	IF (@EndDate IS NULL)
		SELECT @EndDate = CAST(getdate() AS DATE) -- Current date
	
	-- Truncate existing table(s)
	IF OBJECT_ID (N'ourworldindata.CovidDataByDay', N'U') IS NOT NULL
	TRUNCATE TABLE ourworldindata.CovidDataByDay

	IF OBJECT_ID (N'ourworldindata.CovidDataByLocation', N'U') IS NOT NULL
	TRUNCATE TABLE ourworldindata.CovidDataByLocation

	-- Main Query
	-- ---------------------------------------------------------------------------
	;WITH cteTransactions AS (
		SELECT
            CAST([date] AS DATE) AS Date,
                DATEPART(yy, date) AS DateYear,
                DATEPART(mm, date) AS DateMonth,
            --[iso_code] [nvarchar](max) NULL,
            CAST([continent] AS varchar(25)) AS Continent,
            CAST([location] AS varchar(50)) AS Location,
            CAST(CAST([total_cases] AS decimal(20,0)) AS bigint) AS CumulativeCases,
            CAST(CAST([new_cases] AS decimal(20,0)) AS bigint) AS NewCases,
            CAST(CAST([new_cases_smoothed] AS decimal(20,0)) AS bigint) AS NewCasesSmoothed,
            -- [total_deaths],
            CAST(CAST([new_deaths] AS decimal(20,0)) AS bigint) AS NewDeaths,
            CAST(CAST([new_deaths_smoothed] AS decimal(20,0)) AS bigint) AS NewDeathsSmoothed,
            -- [total_cases_per_million],
            CAST(CAST([new_cases_per_million] AS decimal(20,0)) AS bigint) AS NewCasesPerMillion,
            CAST(CAST([new_cases_smoothed_per_million] AS decimal(20,0)) AS bigint) AS NewCasesSmoothedPerMillion,
            -- [total_deaths_per_million],
            CAST(CAST([new_deaths_per_million] AS decimal(20,0)) AS bigint) AS NewDeathsPerMillion,
            CAST(CAST([new_deaths_smoothed_per_million] AS decimal(20,0)) AS bigint) AS NewDeathsSmoothedPerMillion,
            -- [reproduction_rate],
            -- [icu_patients],
            -- [icu_patients_per_million],
            CAST(CAST([hosp_patients] AS decimal(20,0)) AS bigint) AS HospitalizedPatients,
            -- [hosp_patients_per_million],
            -- [weekly_icu_admissions],
            -- [weekly_icu_admissions_per_million],
            -- [weekly_hosp_admissions],
            -- [weekly_hosp_admissions_per_million],
            CAST(CAST([new_tests] AS decimal(20,0)) AS bigint) AS NewTests,
            -- [total_tests],
            -- [total_tests_per_thousand],
            -- [new_tests_per_thousand],
            CAST(CAST([new_tests_smoothed] AS decimal(20,0)) AS bigint) AS NewTestsSmoothed,
            -- [new_tests_smoothed_per_thousand],
            -- [positive_rate],
            -- [tests_per_case],
            -- [tests_units],
            -- [total_vaccinations],
            -- [people_vaccinated],
            -- [people_fully_vaccinated],
            CAST(CAST([new_vaccinations] AS decimal(20,0)) AS bigint) AS NewVaccinations,
            CAST(CAST([new_vaccinations_smoothed] AS decimal(20,0)) AS bigint) AS NewVaccinationsSmoothed
            -- [total_vaccinations_per_hundred],
            -- [people_vaccinated_per_hundred],
            -- [people_fully_vaccinated_per_hundred],
            -- [new_vaccinations_smoothed_per_million],
            -- [stringency_index],
            -- [population],
            -- [population_density],
            -- [median_age],
            -- [aged_65_older],
            -- [aged_70_older],
            -- [gdp_per_capita],
            -- [extreme_poverty],
            -- [cardiovasc_death_rate],
            -- [diabetes_prevalence],
            -- [female_smokers],
            -- [male_smokers],
            -- [handwashing_facilities],
            -- [hospital_beds_per_thousand],
            -- [life_expectancy],
            -- [human_development_index]
		FROM [ourworldindata].[CovidData]
        WHERE [date] < @EndDate -- Exclude current date because it's 0 or incomplete
        AND Continent IS NOT NULL -- Filter totals by contient (ie: World, Europe, North America)
	)
    INSERT INTO [ourworldindata].[CovidDataByDay]
    (
            [Date]
            ,[DateYear]
            ,[DateMonth]
            ,[Continent]
            ,[Location]
            ,[CumulativeCases]
            ,[NewCases]
            ,[NewCasesSmoothed]
            ,[NewDeaths]
            ,[NewDeathsSmoothed]
            ,[NewCasesPerMillion]
            ,[NewCasesSmoothedPerMillion]
            ,[NewDeathsPerMillion]
            ,[NewDeathsSmoothedPerMillion]
            ,[HospitalizedPatients]
            ,[NewTests]
            ,[NewTestsSmoothed]
            ,[NewVaccinations]
            ,[NewVaccinationsSmoothed]
            -- ,[CreatedDate]
            -- ,[CreatedUTCDate]
            -- ,[CreatedByUser]
    )
	SELECT *
	FROM cteTransactions
	--ORDER BY Date

	-- By Location with Ranking
	-- ---------------------------------------------------------------------------
    INSERT INTO [ourworldindata].[CovidDataByLocation] (
        [Location],
	    [SumNewCases],
	    [RankNewCases]
    )
    SELECT Location,
        SUM(ISNULL(NewCases,0)) AS SumNewCases,
        RANK() OVER (ORDER BY SUM(ISNULL(NewCases,0)) DESC) AS RankNewCases
    --INTO owid.OwidCovidDataByLocation
    FROM ourworldindata.CovidDataByDay
    GROUP BY Location
    --ORDER BY SumNewCases DESC

END

/*
	SELECT TOP 1000 * FROM ourworldindata.CovidData ORDER BY date DESC
    SELECT TOP 1000 * FROM ourworldindata.CovidDataByDay
    SELECT MAX(Date) FROM ourworldindata.CovidDataByDay

    SELECT * FROM ourworldindata.CovidDataByLocation

    DROP TABLE ourworldindata.CovidDataByDay
    TRUNCATE TABLE ourworldindata.CovidData
*/