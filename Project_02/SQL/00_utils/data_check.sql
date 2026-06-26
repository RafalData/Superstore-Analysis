/* ======================================================
PLIK:    data_check.sql
PROJEKT: Analiza danych Superstore
AUTOR:   Rafal Borusiewicz
OPIS:    Weryfikacja jakosci danych po imporcie z Excela
========================================================= */

-- --------------------------------------------------------------
-- 1. Sprawdzenie danych po imporcie. 
--    Ilosc wierszy. Typy danych. 
--    Sprawdzenie wartosci NULL / PUSTYCH w kluczowych kolumnach.
-- --------------------------------------------------------------

SELECT COUNT(*) FROM ['Superstore']

-- Ilosc wierszy: 9994

SELECT
COUNT(CASE WHEN [Sales] IS NULL OR [Sales] = ' ' THEN 1 ELSE NULL END) AS Blad_danych_Sales,
COUNT(CASE WHEN [Quantity] IS NULL OR [Quantity] = ' ' THEN 1 ELSE NULL END) AS Blad_danych_Quantity,
COUNT(CASE WHEN [Discount] IS NULL OR [Discount] = ' ' THEN 1 ELSE NULL END) AS Blad_danych_Discount,
COUNT(CASE WHEN [Profit] IS NULL OR [Profit] = ' ' THEN 1 ELSE NULL END) AS Blad_danych_Profit,
COUNT(CASE WHEN [Category] IS NULL OR [Category] = ' ' THEN 1 ELSE NULL END) AS Blad_danych_Category,
COUNT(CASE WHEN [Order date] IS NULL OR [Order date] = ' ' THEN 1 ELSE NULL END) AS Blad_danych_OrderDate,
COUNT(CASE WHEN [Ship Date] IS NULL OR [Ship Date]  = ' ' THEN 1 ELSE NULL END) AS Blad_danych_ShipDate
FROM ['Superstore']

-- wartosci NULL / PUSTYCH w kluczowych kolumnach: 0

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%Superstore%'

/*
Row ID	float
Order ID	nvarchar
Order Date	nvarchar
Ship Date	nvarchar
Ship Mode	nvarchar
Customer ID	nvarchar
Customer Name	nvarchar
Segment	nvarchar
Country	nvarchar
City	nvarchar
State	nvarchar
Postal Code	float
Region	nvarchar
Product ID	nvarchar
Category	nvarchar
Sub-Category	nvarchar
Product Name	nvarchar
Sales	nvarchar
Quantity	float
Discount	nvarchar
Profit	nvarchar
*/

-- Poprawa typow danych

ALTER TABLE ['Superstore']
ALTER COLUMN [Profit] DECIMAL(10, 4)

ALTER TABLE ['Superstore']
ALTER COLUMN [Discount] DECIMAL(10, 4)

ALTER TABLE ['Superstore']
ALTER COLUMN [Sales] DECIMAL(10, 4)

ALTER TABLE ['Superstore']
ALTER COLUMN [QUANTITY] INT

ALTER TABLE ['Superstore']
ALTER COLUMN [Order Date] Date

ALTER TABLE ['Superstore']
ALTER COLUMN [Ship Date] Date

ALTER TABLE ['Superstore']
ALTER COLUMN [Row ID] INT

ALTER TABLE ['Superstore']
ALTER COLUMN [Postal Code] INT
--------------WYNIKI------------------
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%Superstore%'

/*
Row ID	int
Order ID	nvarchar
Order Date	date
Ship Date	date
Ship Mode	nvarchar
Customer ID	nvarchar
Customer Name	nvarchar
Segment	nvarchar
Country	nvarchar
City	nvarchar
State	nvarchar
Postal Code	int
Region	nvarchar
Product ID	nvarchar
Category	nvarchar
Sub-Category	nvarchar
Product Name	nvarchar
Sales	decimal
Quantity	int
Discount	decimal
Profit	decimal
*/

-- --------------------------------------------------------------
-- Dane nie wymagaja dalszej ingerencji
-- --------------------------------------------------------------