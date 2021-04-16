-- Data on COVID-19 (coronavirus) by Our World in Data
-- ----------------------------------------------------------------------------
CREATE SCHEMA owid

SELECT COUNT(*) FROM owid.OwidCovidData --77282

SELECT TOP (1000) *
FROM owid.OwidCovidData

SELECT DISTINCT Continent
FROM owid.OwidCovidData

-- Look for duplicate ISO Codes
;WITH cteDuplicates AS (
    SELECT iso_code,
        ROW_NUMBER() OVER (PARTITION BY iso_code ORDER BY iso_code) AS IsoCodeRowNumber
    FROM owid.OwidCovidData
)
SELECT *
FROM cteDuplicates
WHERE IsoCodeRowNumber > 1