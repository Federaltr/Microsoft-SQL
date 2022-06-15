USE SampleRetail


SELECT A.first_name, A.last_name, 
       DISTINCT B.order_date, MIN(MONTH(B.order_date)) OVER(PARTITION BY B.order_date)
FROM sale.staff A, sale.orders B
WHERE A.store_id = B.store_id AND 
	  YEAR(B.order_date) = 2020 
ORDER BY A.last_name, B.order_date
















