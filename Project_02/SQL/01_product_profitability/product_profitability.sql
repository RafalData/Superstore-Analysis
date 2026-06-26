-- ============================================================
-- ANALIZA: Wplyw kategorii i rabatow na rentownosc produktow
-- ============================================================

-- Cel:
-- Sprawdzenie ktore kategorie oraz poziomy rabatow obnizaja rentownosc firmy.

-- Pytania:
-- 1. Jak wygląda ogólna rentowność firmy?
-- 2. Które kategorie i sub-kategorie odpowiadają za zysk oraz straty?
-- 3. Czy rabaty mogą być związane z niską rentownością?

-- Dodatkowe analizy
-- Identyfikacja produktów odpowiedzialnych za niską rentowność kategorii Furniture.
-- Ocena udziału produktów stratnych w całkowitej sprzedaży kategorii Tables.


--------------------------------------------------------------------------------------------
-- Podsumowanie finansowe: sprzedaz, zysk, strata i marza
--------------------------------------------------------------------------------------------
SELECT
    SUM(Profit) AS Total_Profit,
    SUM(Sales) AS Total_Sales,
    ROUND(SUM(Profit) / SUM(Sales) * 100.0, 2) AS Profit_Margin,
    SUM(CASE WHEN [Profit] < 0 THEN [Profit] 
        ELSE 0 END) AS Total_Loss
FROM ['Superstore']

-- Total_Profit	Total_Sales	  Profit_Margin	 Total_Loss
-- 286397.02	2297200.86	    12.47	     -156131.29

-- Wniosek:
-- Firma generuje zysk na poziomie 286tys przy sprzedazy na poziomie ~2.3 mln.
-- Marza wynosi okolo 12.5%.
-- Czesc produktow generuje straty na poziomie ~156tys, co obniza wynik finansowy.

-- Rekomendacje:
-- Nalezy zidentyfikowac produkty generujace straty.
-- Ograniczyc sprzedaz produktow z niska lub ujemna marza lub dostosowac ich ceny.
-- Przeanalizowac rabaty aby odnalezc glowna przyczyne strat i poprawic rentownosc.

--------------------------------------------------------------------------------------------
-- Ktora kategoria generuje najwiekszy przychod i najwiekszy zysk?
--------------------------------------------------------------------------------------------
SELECT 
    [Category],
    ROUND(SUM(Sales), 2) AS Sales,
    ROUND(SUM(Profit), 2) AS Profit, 
    ROUND(SUM(Profit) / SUM(Sales) * 100.0, 2) AS Profit_Margin
FROM ['Superstore']
GROUP BY Category
ORDER BY SUM(Sales) DESC

-- Category	        Sales	    Profit	    Profit_Margin
-- Technology	    836154.03	145454.95	17.40
-- Furniture	    741999.80	18451.27	2.49
-- Office Supplies	719047.03	122490.80	17.04

-- Wniosek:
-- Kategoria Technology generuje najwyzszy przychod, zysk oraz wysoka marze (~17.4%).
-- Office Supplies osiaga zblizona marze (~17.0%) przy nieco nizszym poziomie sprzedazy.
-- Kategoria Furniture, mimo wysokiej sprzedazy, generuje bardzo niski zysk i marze (~2.5%). Widoczny problem z rentownoscia.

-- Rekomendacje:
-- Przeprowadzic analize produktow kategorii Furniture aby zidentyfikowac powod niskiej rentownosci.
-- Zwiekszenie sprzedazy bez poprawy marzy moze prowadzic do dalszego pogorszenia wynikow finansowych.
-- Warto rozwazyc aktualizacje cen lub ograniczenie promocji dla najmniej oplacalnych produktow.

--------------------------------------------------------------------------------------------
-- Rentownosc sub-kategorii
--------------------------------------------------------------------------------------------
SELECT 
    [Sub-Category],
    ROUND(SUM(Sales), 2) AS Sales,
    ROUND(SUM(Profit), 2) AS Profit, 
    ROUND(SUM(Profit) / SUM(Sales) * 100.0, 2) AS Profit_Margin
FROM ['Superstore']
GROUP BY [Sub-Category]
ORDER BY SUM(Profit) ASC

-- Sub-Category 	Sales	      Profit	  Profit_Margin
-- Tables	    206965.5300 	-17725.4800	    -8.560000
-- Bookcases	114880.0000	    -3472.5600	    -3.020000
-- Supplies	    46673.5400  	-1189.1000	    -2.550000

-- Wniosek:
-- Straty generuja trzy Sub-Kategorie: Tables, Bookcases, Supplies
-- Machines operuje na bardzo niskiej marzy, niska rentownosc.
-- Paper, Envelopes, Labels generuja wysoka marze i wysokie zyski.

-- Rekomendacje:
-- Przeprowadzic analize Tables, Bookcases, Supplies w poszukiwaniu produktow, ktore generuja starty.

--------------------------------------------------------------------------------------------
-- Analiza produktow Sub-Category Tables
--------------------------------------------------------------------------------------------
SELECT 
    [Product Name],
    ROUND(SUM(Sales), 2) AS Sales,
    ROUND(SUM(Profit), 2) AS Profit, 
    ROUND(SUM(Profit) / SUM(Sales) * 100.0, 2) AS Profit_Margin
FROM ['Superstore']
WHERE [Sub-Category]='Tables'
GROUP BY [Product Name]
ORDER BY SUM(profit) ASC

--Za jaki % sprzedaży odpowiadają produkty stratne?

SELECT
    SUM(Sales) AS Total_Sales
FROM ['superstore']
WHERE [Sub-Category] = 'Tables';

206965.5320

SELECT
    SUM(Sales) AS Loss_Product_Sales
FROM
(
    SELECT
        [Product Name],
        SUM(Sales) AS Sales,
        SUM(Profit) AS Profit
    FROM ['Superstore']
    WHERE [Sub-Category] = 'Tables'
    GROUP BY [Product Name]
    HAVING SUM(Profit) < 0
) x;
162823.6165

162823.62 / 206965.53 * 100 = 78.67%

-- Produkty stratne stanowią około 75% portfolio produktów kategorii Tables (42 z 56 produktów). 
-- Odpowiadają za 79% całkowitej sprzedaży kategorii Tables.
-- Problem nie dotyczy więc pojedynczych niszowych produktów, lecz znaczącej części sprzedaży.

--------------------------------------------------------------------------------------------
-- Czy rabaty wplywaja na rentownosc w kategorii Tables?
--------------------------------------------------------------------------------------------
SELECT 
    CASE
        WHEN Discount = 0 THEN '0%'
        WHEN Discount <= 0.2 THEN '0-20%'
        WHEN Discount <= 0.4 THEN '20-40%'
        ELSE '40%+'
    END AS Discount_Group,

    AVG(Profit) AS AVG_Zysk,
    SUM(Profit) AS SUM_Zysk,
    COUNT(*) AS Liczba_Transakcji

FROM ['Superstore']

WHERE [Sub-Category] = 'Tables'

GROUP BY 
    CASE
        WHEN Discount = 0 THEN '0%'
        WHEN Discount <= 0.2 THEN '0-20%'
        WHEN Discount <= 0.4 THEN '20-40%'
        ELSE '40%+'
    END

ORDER BY SUM_Zysk ASC;

-- Discount_Group	AVG_Zysk	SUM_Zysk	Liczba_Transakcji
-- 20-40%	        -151.85	    -19589.72	129
-- 40%+	        -236.35	    -11108.49	47
-- 0-20%	        -4.27	    -303.55	    71
-- 0%	            184.39	    13276.29	72

-- Wniosek:
-- Rabaty maja bezposredni wplyw na rentownosc w kategorii Tables.
-- Najwieksze straty generuja produkty z rabatami powyzej 20%.
-- Grupa 20-40% odpowiada za najwieksza laczna strate ze wzgledu na duza liczbe transakcji.
-- Produkty z rabatami 40%+ maja najwyzsza srednia strate na transakcje.
-- Produkty bez rabatow sa rentowne i generuja wysoki sredni zysk.

-- Rekomendacja:
-- Nalezy ograniczyc poziom rabatow powyzej 20% w kategorii Tables.
-- Skupic sie na optymalizacji produktow z rabatami 20-40%, ktore generuja najwieksza strate.
-- Dla produktow z bardzo wysokimi rabatami (40%+) rozwazyc zmiane strategii cenowej lub ograniczenie sprzedazy.
-- Warto przeprowadzic testy cenowe aby sprawdzic wplyw zmian na sprzedaz i zysk.