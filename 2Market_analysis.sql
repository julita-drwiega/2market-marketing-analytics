-- create marketing data table:

CREATE TABLE marketing_data(
	"ID" BIGSERIAL PRIMARY KEY,
	"Year_Birth" NUMERIC(4),
	"Age" NUMERIC,
	"Education" VARCHAR(30),
	"Marital_Status" VARCHAR(30),
	"Income" VARCHAR(10),
	"Kidhome" INTEGER,
	"Teenhome" INTEGER,
	"Dt_Customer" VARCHAR(10),
	"Recency" INTEGER,
	"AmtLiq" NUMERIC,
	"AmtVege" NUMERIC,
	"AmtNonVeg" NUMERIC,
	"AmtPes" NUMERIC,
	"AmtChocolates" NUMERIC,
	"AmtComm" NUMERIC,
	"NumDeals" NUMERIC,
	"NumWebBuy" NUMERIC,
	"NumWalkinPur" NUMERIC,
	"NumVisits" NUMERIC,
	"Response" NUMERIC,
	"Complain" NUMERIC,
	"Country" VARCHAR(10),
	"Count_success" NUMERIC);

SELECT * FROM marketing_data;

-- create ad data table:

CREATE TABLE ad_data(
	"ID" BIGSERIAL PRIMARY KEY,
	"Bulkmail_ad" INTEGER,
	"Twitter_ad" INTEGER,
	"Instagram_ad" INTEGER,
	"Facebook_ad" INTEGER,
	"Brochure_ad" INTEGER);

SELECT * FROM ad_data;

SELECT DISTINCT "Country"
	FROM marketing_data;

-- show number of customers from each country:

SELECT "Country", COUNT("Country") AS number_of_customers
FROM marketing_data
GROUP BY "Country"
ORDER BY number_of_customers DESC;

-- show number of customers from each country and % of total customers for each country:

SELECT 
	"Country",
	COUNT(*) AS number_of_customers,
	ROUND(
		COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2
	) AS pct_of_total
FROM marketing_data
GROUP BY "Country"
ORDER BY number_of_customers DESC;


-- show total sales per country, and percentage of total sales:

SELECT 
	"Country", 
	SUM(
		"AmtLiq"
		+ "AmtVege"
		+ "AmtNonVeg"
		+ "AmtPes"
		+ "AmtChocolates"
		+ "AmtComm"
		) AS total_sales,
		ROUND(
			SUM(
				"AmtLiq" 
				+ "AmtVege" 
				+ "AmtNonVeg" 
				+ "AmtPes" 
				+ "AmtChocolates" 
				+ "AmtComm") * 100.0 
				/ SUM(
					SUM(
						"AmtLiq" 
						+ "AmtVege" 
						+ "AmtNonVeg" 
						+ "AmtPes" 
						+ "AmtChocolates" 
						+ "AmtComm"
						)
				) OVER(), 2
		) AS pct_of_total
FROM marketing_data
GROUP BY "Country"
ORDER BY total_sales DESC;

-- show total sales per category:

SELECT SUM("AmtLiq") AS liquor_sales,
	SUM("AmtVege") AS vegetable_sales,
	SUM("AmtNonVeg") AS meat_sales,
	SUM("AmtPes") AS fish_sales,
	SUM("AmtChocolates") AS chocolate_sales,
	SUM("AmtComm") AS commodities_sales
FROM marketing_data;

-- show total sales per category per country:

SELECT 
	"Country",
	SUM("AmtLiq") AS liquor_sales,
	SUM("AmtVege") AS vegetable_sales,
	SUM("AmtNonVeg") AS meat_sales,
	SUM("AmtPes") AS fish_sales,
	SUM("AmtChocolates") AS chocolate_sales,
	SUM("AmtComm") AS commodities_sales,
	SUM("AmtLiq" + "AmtVege" + "AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm") AS total_sales
FROM marketing_data
GROUP BY "Country"
ORDER BY total_sales DESC;

-- create temporary table to show total sales per category per country:

CREATE TEMP TABLE country_sales AS 
SELECT 
	"Country",
	SUM("AmtLiq") AS liquor_sales,
	SUM("AmtVege") AS vegetable_sales,
	SUM("AmtNonVeg") AS meat_sales,
	SUM("AmtPes") AS fish_sales,
	SUM("AmtChocolates") AS chocolate_sales,
	SUM("AmtComm") AS commodities_sales,
	SUM("AmtLiq" + "AmtVege" + "AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm") AS total_sales
FROM marketing_data
GROUP BY "Country";

-- show total liquor and meat sales and their percentages, per country:

SELECT 
	"Country",
	liquor_sales,
	ROUND(
		liquor_sales * 100.0 
		/ SUM(liquor_sales) OVER(), 2
	) AS pct_of_total_liquor_sales,
	meat_sales,
	ROUND(
		meat_sales * 100.0 
		/ SUM(meat_sales) OVER(), 2
	) AS pct_of_total_meat_sales,
	total_sales
FROM country_sales
ORDER BY total_sales DESC;

SELECT * FROM marketing_data;

-- show total sales per category per marital status:

SELECT 
	"Marital_Status",
	SUM("AmtLiq") AS liquor_sales,
	SUM("AmtVege") AS vegetable_sales,
	SUM("AmtNonVeg") AS meat_sales,
	SUM("AmtPes") AS fish_sales,
	SUM("AmtChocolates") AS chocolate_sales,
	SUM("AmtComm") AS commodities_sales,
	SUM("AmtLiq" + "AmtVege" + "AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm") AS total_sales
FROM marketing_data
GROUP BY "Marital_Status"
ORDER BY total_sales DESC;

-- total sales per category per kids home:

SELECT 
	"Kidhome",
	SUM("AmtLiq") AS liquor_sales,
	SUM("AmtVege") AS vegetable_sales,
	SUM("AmtNonVeg") AS meat_sales,
	SUM("AmtPes") AS fish_sales,
	SUM("AmtChocolates") AS chocolate_sales,
	SUM("AmtComm") AS commodities_sales,
	SUM("AmtLiq" + "AmtVege" + "AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm") AS total_sales
FROM marketing_data
GROUP BY "Kidhome"
ORDER BY total_sales DESC;

-- total sales per category per teens home:

SELECT 
	"Teenhome",
	SUM("AmtLiq") AS liquor_sales,
	SUM("AmtVege") AS vegetable_sales,
	SUM("AmtNonVeg") AS meat_sales,
	SUM("AmtPes") AS fish_sales,
	SUM("AmtChocolates") AS chocolate_sales,
	SUM("AmtComm") AS commodities_sales,
	SUM("AmtLiq" + "AmtVege" + "AmtNonVeg" + "AmtPes" + "AmtChocolates" + "AmtComm") AS total_sales
FROM marketing_data
GROUP BY "Teenhome"
ORDER BY total_sales DESC;

-- join both tables:

CREATE TABLE sales AS 
	SELECT 
	md."ID", 
	"Age", 
	"Country",
	"Education",
	"Marital_Status",
	"Income",
	"Kidhome",
	"Teenhome",
	"AmtLiq", 
	"AmtVege", 
	"AmtNonVeg", 
	"AmtPes", 
	"AmtChocolates",
	"AmtComm", 
	(
		"AmtLiq" 
		+ "AmtVege" 
		+ "AmtNonVeg" 
		+ "AmtPes" 
		+ "AmtChocolates" 
		+ "AmtComm"
	) AS total_sales, 
	ad."Bulkmail_ad", 
	"Twitter_ad", 
	"Instagram_ad", 
	"Facebook_ad", 
	"Brochure_ad", 
	"Count_success"
	FROM marketing_data md
	JOIN ad_data ad
	USING ("ID");

SELECT * FROM sales;

-- calculate total sales and ads for each customer

SELECT "ID", "Count_success", "total_sales"
FROM sales
ORDER BY "Count_success" DESC;

-- group ads and sales by country:

CREATE TEMP TABLE country_ads AS
SELECT "Country",
	SUM("Bulkmail_ad") AS bulkmail, 
	SUM("Twitter_ad") AS twitter, 
	SUM("Instagram_ad") AS instagram, 
	SUM("Facebook_ad") AS facebook, 
	SUM("Brochure_ad") AS brochure,
	SUM("Count_success") AS conversions,
	SUM("total_sales") AS total_sales
FROM sales
GROUP BY "Country"
ORDER BY total_sales DESC;

SELECT * FROM country_ads;

-- calculate total conversions per marketing channel, and their % of total conversions:

SELECT channel, 
	total_conversions,
	ROUND(total_conversions * 100.0 / SUM(total_conversions) OVER(), 2
	) AS pct_of_total
FROM (
SELECT 'bulkmail' AS channel, SUM("bulkmail") AS total_conversions
FROM country_ads
UNION 
SELECT 'twitter', SUM("twitter")
FROM country_ads
UNION 
SELECT 'instagram', SUM("instagram")
FROM country_ads
UNION 
SELECT 'facebook', SUM("facebook")
FROM country_ads
UNION 
SELECT 'brochure', SUM("brochure")
FROM country_ads)
ORDER BY total_conversions DESC;

-- group ads and sales by marital status:

SELECT "Marital_Status",
	SUM("Bulkmail_ad") AS bulkmail, 
	SUM("Twitter_ad") AS twitter, 
	SUM("Instagram_ad") AS instagram, 
	SUM("Facebook_ad") AS facebook, 
	SUM("Brochure_ad") AS brochure,
	SUM("Count_success") AS conversions,
	SUM("total_sales") AS total_sales
FROM sales
GROUP BY "Marital_Status"
ORDER BY total_sales DESC;

-- calculate sales per product per country and ads per country

SELECT "Country",
	SUM("AmtLiq") AS liquor_sales,
	SUM("AmtVege") AS vegetable_sales,
	SUM("AmtNonVeg") AS meat_sales,
	SUM("AmtPes") AS fish_sales,
	SUM("AmtChocolates") AS chocolate_sales,
	SUM("AmtComm") AS commodities_sales,
	SUM("Bulkmail_ad") AS bulkmail, 
	SUM("Twitter_ad") AS twitter, 
	SUM("Instagram_ad") AS instagram, 
	SUM("Facebook_ad") AS facebook, 
	SUM("Brochure_ad") AS brochure,
	SUM("Count_success") AS conversions,
	SUM("total_sales") AS total_sales
FROM sales
GROUP BY "Country"
ORDER BY total_sales DESC;
