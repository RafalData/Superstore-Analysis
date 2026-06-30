-- ============================================================
-- ANALIZA: Rentowność regionów i identyfikacja problemów
-- ============================================================

-- CEL:
-- Ocena rentowności poszczególnych regionów oraz identyfikacja obszarów
-- wymagających poprawy.

-- ============================================================
-- Analiza sprzedaży, zysku i marży
-- ============================================================
SELECT
	[Region],
	SUM([Sales]) as Sprzedaz,
	SUM([Profit]) as Zysk,
	ROUND(SUM(Profit) / SUM(Sales) * 100.0, 2) AS Marza
FROM ['Superstore']
GROUP BY [Region]
ORDER BY Zysk desc

-- Region	Sprzedaz	Zysk	    Marza
-- West	    725457.82	108418.45	14.94
-- East	    678781.24	91522.78	13.48
-- South	391721.91	46749.43	11.93
-- Central	501239.89	39706.36	7.92

-- Wnioski:
-- Najwyższą sprzedaż, zysk i marżę generuje region WEST.
-- Region Central osiąga najniższą rentowność.
-- Region South osiąga najniższą wartość sprzedaży.
-- Marża regionu Central (7.92%) jest wyraźnie niższa od marży regionu West (14.94%).

-- Rekomendacje: 
-- Przeanalizować przyczyny niższej rentowności regionu Central.
-- Sprawdzić, czy wynik ten wynika z poszczególnych stanów, czy dotyczy całego regionu.

-- ============================================================
-- Analiza rentownosci obszarow w regionie Central
-- ============================================================
SELECT
	[State],
	ROUND(SUM([Sales]), 2) as Sprzedaz,
	ROUND(SUM([Profit]), 2) as Zysk,
	ROUND(SUM(Profit) / SUM(Sales) * 100.0, 2) AS Marza
FROM ['Superstore']
WHERE [Region] = 'Central'
GROUP BY [State]
ORDER BY Zysk desc

-- State	    Sprzedaz	Zysk	Marza
-- Michigan	    76269.6140	24463.1876	32.070000
-- Indiana	    53555.3600	18382.9363	34.330000
-- Minnesota	29863.1500	10823.1874	36.240000
-- Wisconsin	32114.6100	8401.8004	26.160000
-- Missouri	    22205.1500	6436.2105	28.990000
-- Oklahoma	    19683.3900	4853.9560	24.660000
-- Nebraska	    7464.9300	2037.0942	27.290000
-- Iowa	        4579.7600	1183.8119	25.850000
-- Kansas	    2914.3100	836.4435	28.700000
-- South Dakota	1315.5600	394.8283	30.010000
-- North Dakota	919.9100	230.1497	25.020000
-- Illinois	    80166.1010	-12607.8870	-15.730000
-- Texas	    170188.0458	-25729.3563	-15.120000

--  Wnioski: 
-- Texas i Illinois zajmują pierwsze miejsca pod względem wartości sprzedaży, 
-- jednocześnie będąc jedynymi stanami w regionie Central generującymi straty.
-- Mają wyraźny wpływ ma wynik całego regionu.
-- Najwyższą marżę generują Indiana, Michigan, Minnesota oraz South Dakota (powyżej 30%).

-- Rekomendacje:
-- Przeanalizowac strukture kategorii produktów w stanach Texas i Illinois,
-- aby odnaleźć przyczyny niskiej rentowności.

-- ============================================================
-- Ktore kategorie generuja straty w stanach Texas i Illinois?
-- ============================================================
SELECT
	[State],
	[Category],
	SUM(Profit) as Zysk
FROM ['Superstore']
WHERE [State] = 'Texas' OR [State] = 'Illinois'
GROUP BY [Category], [State]
ORDER BY [State], Zysk 

--State	    Category	    Zysk
-- Illinois	Furniture	    -9076.2894
-- Illinois	Office Supplies	-8354.1568
-- Illinois	Technology	    4822.5592
-- Texas	Office Supplies	-18584.6434
-- Texas	Furniture	    -10436.1419
-- Texas	Technology	    3291.4290

-- Wnioski:
-- W obu stanach kategorie Furniture oraz Office Supplies generują straty.
-- Jedyną rentowną kategorią jest Technology. 

-- ============================================================
-- Analiza sub-kategorii w stanach Texas i Illinois
-- ============================================================
SELECT
	[Sub-Category],
	[Category],
	SUM(Profit) as Zysk,
	ROUND
	(
		Sum(sales) *100.00 /
		(
			SELECT SUM(SALES)
			FROM ['Superstore']
			WHERE [State] IN ('Texas','Illinois')
		), 
	2) as Procent_calkowitej_Sprzedazy
FROM ['Superstore']
WHERE [State] IN ('Texas','Illinois')
GROUP BY [Sub-Category] , [Category]
ORDER BY Zysk, [Sub-Category]

--Sub-Category	Category		Zysk		Procent_calkowitej_Sprzedazy
--Binders		Office Supplies	-21909.3980	5.42
--Appliances	Office Supplies	-8629.6412	1.35
--Tables		Furniture		-6526.4213	8.91
--Furnishings	Furniture		-5944.6552	2.65
--Chairs		Furniture		-4094.3445	16.43
--Bookcases		Furniture		-2947.0103	7.50
--Machines		Technology		-2340.8039	9.31
--Storage		Office Supplies	-1021.1638	9.91
--Supplies		Office Supplies	-823.8522	1.88
--Fasteners		Office Supplies	124.7306	0.19
--Labels		Office Supplies	277.8642	0.32
--Art			Office Supplies	455.3079	1.32
--Envelopes		Office Supplies	980.7054	1.16
--Accessories	Technology		2087.7145	6.74
--Copiers		Technology		3461.9281	4.62
--Paper			Office Supplies	3606.6469	4.17
--Phones		Technology		4905.1495	18.12

-- Wnioski:
-- Subkategoria Binders generuje największą stratę (-21,9 tys.),
-- mimo że odpowiada za jedynie 5,42% całkowitej sprzedaży analizowanych stanów.
-- udział w całkowitej sprzedaży to nie całe 5,5%.
-- Sub-kategorie przynoszące starty to Binders, Appliances, Tables, Furnishings, Chairs, Bookcases, 
-- Machines oraz Storage.
-- Subkategoria Phones odpowiada za największy udział w sprzedaży (18,12%) i pozostaje rentowna, 
-- natomiast Chairs odpowiada za 16,43% sprzedaży, jednocześnie generując straty.
