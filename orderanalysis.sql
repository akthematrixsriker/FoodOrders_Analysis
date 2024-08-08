/*CREATE TABLE restaurant_orders (
	date DATE,
	vendor_id INT,
	chain_id INT,
	city_id INT,
	spec VARCHAR(255),
	successful_orders FLOAT,
	fail_orders FLOAT
);


-- Check Null Values

SELECT * FROM restaurant_orders
WHERE date is null OR vendor_id is null OR chain_id is null OR city_id is null OR spec is null OR successful_orders is null OR  fail_orders is null;

-- Remove or handle NULL Values
DELETE FROM restaurant_orders
WHERE date is null OR vendor_id is null OR chain_id is null OR city_id is null OR spec is null OR successful_orders is null OR  fail_orders is null;

-- Check for duplicate rows
DELETE FROM restaurant_orders WHERE city_id
NOT IN(
SELECT MIN(city_id)
FROM restaurant_orders GROUP BY date, vendor_id,
chain_id, city_id, spec, successful_orders, fail_orders
);
*/

-- Get the Total Orders Of Successful And Fail Orders
SELECT SUM(successful_orders) AS total_successful,
SUM(fail_orders) AS total_faild
FROM restaurant_orders;

-- Get the Number Of Restaurents Per Specialization
SELECT spec, COUNT(DISTINCT(vendor_id))AS num_restaurents
FROM restaurant_orders
GROUP BY spec;

-- Get the Total Number of Successful Orders and Faild Ordes per city; 
SELECT city_id, 
SUM(successful_orders) AS total_successful,
SUM (fail_orders) AS total_faild
FROM restaurant_orders
GROUP BY city_id;

-- Get the Average Orders per Day
SELECT date,
AVG(successful_orders+fail_orders) AS avg_orders
FROM restaurant_orders
GROUP BY date
ORDER BY date;

-- Get the Top 4 Cities by Total Orders
SELECT city_id,
SUM(successful_orders + fail_orders) AS total_orders
FROM restaurant_orders
GROUP BY city_id
ORDER BY total_orders
LIMIT 4;

-- Success Rate by Specilization 
SELECT spec,
SUM(successful_orders) AS total_successful,
SUM(fail_orders) AS total_faild,
(SUM(successful_orders) * 100 / (SUM(successful_orders) + SUM(fail_orders))) as success_rate
from restaurant_orders
GROUP BY spec;


-- Top 5 Chains by Success Rate
SELECT chain_id, 
SUM(successful_orders) AS total_successful, 
SUM(fail_orders) AS total_failed,
CASE 
WHEN SUM(successful_orders) + SUM(fail_orders) = 0 THEN 0
ELSE (SUM(successful_orders) * 100 / (SUM(successful_orders) + SUM(fail_orders)))
END AS success_rate
FROM restaurant_orders
GROUP BY chain_id
ORDER BY success_rate DESC
LIMIT 5;

-- Top 5 Cities By Success Rate
SELECT city_id,
SUM (successful_orders) AS total_successful,
SUM(fail_orders) AS total_failed,
(SUM(successful_orders) * 100 / (SUM(successful_orders) + SUM(fail_orders))) AS success_rate
FROM restaurant_orders
GROUP BY (city_id)
ORDER BY success_rate
LIMIT 3;

-- Daily Order Trend For A Specific Chain
SELECT date,
SUM( successful_orders+ fail_orders) AS total_rate
FROM restaurant_orders
WHERE chain_id = 7501
GROUP BY date
ORDER BY DATE;
 

-- Monthly Order Trends
SELECT date_trunc ('month', date)
AS month, spec,
SUM (successful_orders) AS total_successful,
SUM(fail_orders) AS total_failed,
(SUM(successful_orders) * 100 / (SUM(successful_orders) + SUM(fail_orders))) AS success_rate
FROM restaurant_orders
GROUP BY month, spec
ORDER BY month, spec;

-- Indentify the peak order days
SELECT date,
SUM( successful_orders+ fail_orders) AS total_orders
FROM restaurant_orders
GROUP BY date
ORDER BY total_orders DESC;

-- Performance analysis vendor  within a city
SELECT vender_id,
SUM (successful_orders) AS total_successful,
SUM(fail_orders) AS total_failed,
CASE
WHEN SUM(successful_orders) + SUM(fail_orders) = 0 THEN 0
ELSE (SUM(successful_orders) * 100 / (SUM(successful_orders) + SUM(fail_orders)))
END AS success_rate
FROM restaurant_orders
WHERE city_iD = 26
GROUP BY vender_id;

-- Analyzing Order Failure Patterns
SELECT date,
SUM(fail_orders) AS total_orders
FROM restaurant_orders
GROUP BY date
ORDER BY total_orders DESC
LIMIT 10;