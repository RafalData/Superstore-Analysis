Select 
	CASE
        WHEN Discount = 0 THEN '0%'
        WHEN Discount <= 0.2 THEN '0-20%'
        WHEN Discount <= 0.4 THEN '20-40%'
        ELSE '40%+'
    END as Discount_Group,

    AVG(Profit) AS AVG_Zysk,
    SUM(Profit) AS SUM_Zysk,
    COUNT(*) AS Liczba_Transakcji
from ['Superstore']

Where [Sub-Category] = 'Tables'
GROUP BY CASE 
        WHEN Discount = 0 THEN '0%'
        WHEN Discount <= 0.2 THEN '0-20%'
        WHEN Discount <= 0.4 THEN '20-40%'
        ELSE '40%+'
        END
ORDER BY SUM_Zysk ASC