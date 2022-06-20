
/* 
List the employee's first order dates by month in 2020. 
Expected columns are: first name, last name, month and the first order date. (last name and month in ascending order)
(Use SampleRetail Database and paste your result in the box below.)
*/


USE SampleRetail


SELECT A.first_name, A.last_name, MONTH(B.order_date), MIN(B.order_date)
FROM sale.staff A, sale.orders B
WHERE A.store_id = B.store_id AND 
	  YEAR(B.order_date) = 2020 
GROUP BY A.first_name, A.last_name, MIN(B.order_date)
ORDER BY A.last_name, B.order_date
 



/*

Write a query using the window function that 
returns staffs' first name, last name, and their total net amount of orders in descending order.

(Use SampleRetail Database and paste your result in the box below.)

*/

SELECT DISTINCT A.first_name, A.last_name, 
	   SUM(C.list_price * C.quantity * (1 - C.discount)) OVER(PARTITION BY A.first_name, A.last_name)
FROM sale.staff A, sale.orders B, sale.order_item C
WHERE A.staff_id = B.staff_id AND
	  B.order_id = C.order_id
ORDER BY 3 DESC


/*

Write a query using the window function that returns the cumulative total 
turnovers of the Burkes Outlet by order date between "2019-04-01" and "2019-04-30".

Columns that should be listed are: 'order_date' in ascending order and 'Cumulative_Total_Price'.

*/


SELECT DISTINCT A.order_date,
	   SUM(C.list_price * C.quantity ) OVER(ORDER BY A.order_date) Cumulative_Total_Price
FROM sale.orders A, sale.store B, sale.order_item C
WHERE A.store_id = B.store_id AND
	  A.order_id = C.order_id AND 
	  B.store_name = 'Burkes Outlet' AND
	  A.order_date BETWEEN '2019-04-01' AND '2019-04-30' 

---






	   







































