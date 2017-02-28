-- WHERE

-- What is the populationg of the US
SELECT
  name,
  population
FROM
  country
WHERE
  code = 'USA';

-- What is the are of the US
SELECT
  name,
  surfacearea
FROM
  country
WHERE
  code2 = 'US';

-- List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45
SELECT
  name,
  population,
  lifeexpectancy,
  continent
FROM
  country
WHERE
  continent = 'Africa'
  AND
  population < 3e+7
  AND
  lifeexpectancy > 45;

-- Which countries are something like a republic
SELECT
  name,
  governmentform
FROM
  country
WHERE
  governmentform LIKE '%Republic%';

-- Which countries are some kind of republic and acheived independence after 1945
SELECT
  name,
  governmentform,
  indepyear
FROM
  country
WHERE
  governmentform LIKE '%Republic%'
  AND
  indepyear > 1945;

-- Which countries acheived independence after 1945 and are not some kind of republic
SELECT
  name,
  governmentform
FROM
  country
WHERE
  indepyear > 1945
  AND
  governmentform NOT LIKE '%Republic%';

-- ORDER BY

-- Which fifteen countries have the lowest life expectancy?  Highest?
-- Lowest

SELECT
  name,
  continent,
  lifeexpectancy
FROM
  country
ORDER BY
  lifeexpectancy ASC
LIMIT 15;

-- Highest

SELECT
  name,
  continent,
  lifeexpectancy
FROM
  country
WHERE
  lifeexpectancy > 0
ORDER BY
  lifeexpectancy DESC
LIMIT 15;

-- Which 5 countries have the lowest population density?

SELECT
  name,
  continent,
  population,
  surfacearea
FROM
  country
WHERE
  population > 0
ORDER BY
  population / surfacearea ASC
LIMIT 5;


-- Which 5 countries have the highest population density?

SELECT
  name,
  continent,
  population,
  surfacearea
FROM
  country
WHERE
  population > 0
ORDER BY
  population / surfacearea DESC
LIMIT 5;

-- Which is the smallest country, by area and population?
SELECT
  name,
  continent,
  population,
  surfacearea
FROM
  country
WHERE
  surfacearea > 0
  AND
  population > 0
ORDER BY
  surfacearea * population ASC
LIMIT 1;

-- 10 smallest countries by area and population
SELECT
  name,
  continent,
  population,
  surfacearea
FROM
  country
WHERE
  surfacearea > 0
  AND
  population > 0
ORDER BY
  surfacearea * population ASC
LIMIT 10;

-- Which is the biggest country, by area and population?
SELECT
  name,
  continent,
  population,
  surfacearea
FROM
  country
WHERE
  surfacearea > 0
  AND
  population > 0
ORDER BY
  surfacearea * population DESC
LIMIT 1;

-- 10 biggest countries by area and population
SELECT
  name,
  continent,
  population,
  surfacearea
FROM
  country
WHERE
  surfacearea > 0
  AND
  population > 0
ORDER BY
  surfacearea * population DESC
LIMIT 10;

-- WITH
-- Of the smallest 10 countries, which has the biggest gnp
WITH
  smallest AS
  (SELECT
    name,
    continent,
    population,
    surfacearea,
    gnp
  FROM
    country
  WHERE
    surfacearea > 0
  AND
    population > 0
  ORDER BY
    surfacearea * population ASC
  LIMIT 10)
SELECT
  name,
  continent,
  population,
  surfacearea,
  gnp
FROM
  smallest
ORDER BY
  gnp ASC
LIMIT 1;

-- Of the smallest 10 countries, which has the biggest per capita gnp?
WITH
  smallest AS
  (SELECT
    name,
    continent,
    population,
    surfacearea,
    gnp
  FROM
    country
  WHERE
    surfacearea > 0
  AND
    population > 0
  ORDER BY
    surfacearea * population ASC
  LIMIT 10)
SELECT
  name,
  continent,
  population,
  surfacearea,
  gnp,
  gnp / population AS gnp_per_capita
FROM
  smallest
ORDER BY
  gnp DESC
LIMIT 1;

-- Of the biggest 10 countries, which has the biggest gnp?
WITH
  biggest AS
  (SELECT
    name,
    continent,
    population,
    surfacearea,
    gnp
  FROM
    country
  WHERE
    surfacearea > 0
    AND
    population > 0
  ORDER BY
    surfacearea * population DESC
  LIMIT 10)
SELECT
  name,
  continent,
  population,
  surfacearea,
  gnp
FROM
  biggest
ORDER BY
  gnp DESC
LIMIT 1;

-- Of the biggest 10 countries, which has the biggest gnp per capita?
WITH
  biggest AS
  (SELECT
    name,
    continent,
    population,
    surfacearea,
    gnp
  FROM
    country
  WHERE
    surfacearea > 0
    AND
    population > 0
  ORDER BY
    surfacearea * population DESC
  LIMIT 10)
SELECT
  name,
  continent,
  population,
  surfacearea,
  gnp,
  gnp / population AS gnp_per_capita
FROM
  biggest
ORDER BY
  gnp_per_capita DESC
LIMIT 1;

-- What is the sum of surface area of the 10 biggest countries in the world?
WITH
  biggest AS
  (SELECT
    name,
    continent,
    population,
    surfacearea,
    gnp
  FROM
    country
  WHERE
    surfacearea > 0
    AND
    population > 0
  ORDER BY
    surfacearea * population DESC
  LIMIT 10)
SELECT
  SUM(surfacearea) AS total_surface_area
FROM
  biggest;

-- What is the sum of surface area of the 10 smallest countries in the world?
WITH
  smallest AS
  (SELECT
    name,
    continent,
    population,
    surfacearea,
    gnp
  FROM
    country
  WHERE
    surfacearea > 0
  AND
    population > 0
  ORDER BY
    surfacearea * population ASC
  LIMIT 10)
SELECT
  SUM(surfacearea) AS total_surface_area
FROM
  smallest;

-- GROUP BY

-- How big are the continents in term of area and population?
SELECT
  continent,
  SUM(surfacearea) AS total_surface_area,
  SUM(population) AS total_population
FROM
  country
GROUP BY
  continent;

-- Which region has the highest average gnp?
SELECT
  region,
  AVG(gnp) AS average_gnp
FROM
  country
GROUP BY
  region;

-- Who is the most influential head of state measured by population?
SELECT
  headofstate,
  population
FROM
  country
ORDER BY
  population DESC
LIMIT 1;

-- Who is the most influential head of state measured by surface area?
SELECT
  headofstate,
  surfacearea
FROM
  country
ORDER BY
  surfacearea DESC
LIMIT 1;

-- What are the most common forms of government?
SELECT
  governmentform,
  count(governmentform) AS number_of_governments
FROM
  country
GROUP BY
  governmentform
ORDER BY
  number_of_governments DESC;

-- What are the forms of government for the top ten countries by surface area
WITH
  biggest AS
  (SELECT
    name,
    surfacearea,
    governmentform,
    population
  FROM
    country
  WHERE
    surfacearea > 0
    AND
    population > 0
  ORDER BY
    surfacearea DESC
  LIMIT 10)
SELECT
  governmentform,
  count(governmentform) AS number_of_governments
FROM
  biggest
GROUP BY
  governmentform
ORDER BY
  number_of_governments DESC;

-- What are the forms of government for the top ten richest nations?
WITH
  richest AS
  (SELECT
    name,
    gnp,
    governmentform
  FROM
    country
  WHERE
    gnp > 0
  ORDER BY
    gnp DESC
  LIMIT 10)
SELECT
  governmentform,
  count(governmentform) AS number_of_governments
FROM
  richest
GROUP BY
  governmentform
ORDER BY
  number_of_governments DESC;

-- What are the forms of government for the top ten richest per capita nations? (technically most productive)
WITH
  richest AS
  (SELECT
    name,
    gnp,
    governmentform,
    population,
    gnp / population AS gnp_per_capita
  FROM
    country
  WHERE
    gnp > 0
  ORDER BY
    gnp_per_capita DESC
  LIMIT 10)
SELECT
  governmentform,
  count(governmentform) AS number_of_governments
FROM
  richest
GROUP BY
  governmentform
ORDER BY
  number_of_governments DESC;

-- Which countries are in the top 5% in terms of area?
-- (hint: use a SELECT in a LIMIT clause)

SELECT
  name,
  code,
  surfacearea,
  governmentform,
  population
FROM
  country
WHERE
  surfacearea > 0
  AND
  population > 0
ORDER BY
  surfacearea DESC
LIMIT (SELECT count(*)*0.05 FROM country);


-- What is the 3rd most common language spoken?
WITH pop_of_speakers AS
  (SELECT
    code,
    population
  FROM
    country)
AND WITH
SELECT
  countrycode,
  count(language) AS occurance
FROM
  countrylanguage
GROUP BY
  language
ORDER BY
  number_of_speakers DESC;

-- How many cities are in Chile?
SELECT
  countrycode,
  count(countrycode) AS number_of_cities
FROM
  city
WHERE
  countrycode = 'CHL'
GROUP BY
  countrycode;

-- WHat is the total population in China
SELECT
  code,
  population
FROM
  country
WHERE
  code = 'CHN';

-- How many countries are in North America?
SELECT
  continent,
  count(continent) AS number_of_countries
FROM
  country
WHERE
  continent = 'North America'
GROUP BY
  continent;
