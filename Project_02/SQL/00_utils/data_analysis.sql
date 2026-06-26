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

--------------------------------------------------------------------------------------------
-- Ktory region generuje najwiekszy zysk i gdzie wystepuje problem z rentownoscia?
--------------------------------------------------------------------------------------------
SELECT
    [Region],
    SUM(Sales) AS Przychod,
    SUM(Profit) AS Zysk,
    ROUND(SUM(Profit) / SUM(Sales) * 100.0, 2) AS Marza
FROM ['Superstore']
GROUP BY [Region]
ORDER BY Zysk DESC

-- Region	    Przychod	    Zysk	    Marza
-- West	        725457.82	    108418.45	14.94
-- East	        678781.24	    91522.78	13.48
-- South	    391721.91	    46749.43	11.93
-- Central	    501239.89	    39706.36	7.92

-- Wniosek:
-- Region West generuje najwyzszy zysk oraz najwyzsza marze (~15%), co wskazuje na wysoka efektywnosc sprzedazy.
-- Region East rowniez osiaga dobre wyniki przy wysokiej marzy (~13.5%).
-- Region South mimo nizszego przychodu utrzymuje stabilna rentownosc (~12%).
-- Region Central generuje najnizszy zysk oraz najnizsza marze (~8%), co wskazuje na problem z rentownoscia.

-- Rekomendacja:
-- Nalezy przeanalizowac region Central w celu zidentyfikowania przyczyn niskiej rentownosci.
-- Warto sprawdzic czy problem wynika z rabatow, struktury produktow lub kosztow.
-- Region West moze posluzyc jako benchmark do porownania efektywnosci sprzedazy w innych regionach.

--------------------------------------------------------------------------------------------
-- Badanie przyczyny niskiej rentownosci w regionie Central
--------------------------------------------------------------------------------------------
SELECT
    Region,
    AVG(Discount) AS AVG_Rabat,
    SUM(Profit) AS Zysk
FROM ['Superstore']
GROUP BY Region
ORDER BY AVG_Rabat DESC

-- Region	    AVG_Rabat	    Zysk
-- Central	    0.240352	    39706.36
-- South	    0.147253	    46749.43
-- East	        0.145365	    91522.78
-- West	        0.109334	    108418.45

-- Wniosek:
-- Region Central ma najwyzszy poziom rabatow (~24%) oraz najnizszy zysk.
-- Region West ma najnizsze rabaty (~11%) oraz najwyzszy zysk.
-- Wyzsze rabaty nie przekladaja sie na lepsze wyniki finansowe, a moga obnizac rentownosc.

-- Rekomendacje:
-- Nalezy ograniczyc poziom rabatow w regionie Central, szczegolnie dla produktow o niskiej rentownosci.
-- Warto przeanalizowac ktore produkty w regionie Central sa sprzedawane z najwyzszymi rabatami i generuja straty.
-- Region West moze posluzyc jako punkt odniesienia do optymalizacji polityki cenowej.