---- C-11 WEEKLY AGENDA-6 RD&SQL STUDENT

---- 1. List all the cities in the Texas and the numbers of customers in each city.----

  SELECT customer.city, COUNT(customer.customer_id) AS number_of_customer
  FROM sale.customer
  WHERE state = 'TX'
  GROUP BY city;

---- 2. List all the cities in the California which has more than 35 customer, by showing the cities which have more customers first.---

  SELECT customer.city, COUNT(customer_id) AS customer_count
  FROM sale.customer
  WHERE state = 'CA'
  GROUP BY city
  HAVING COUNT(customer_id) > 35  --where'de aggregate func. kullanýlamadýðý için having kullandýk.
  ORDER BY COUNT(customer_id) DESC

---- 3. List the top 10 most expensive products----

  SELECT TOP 10 product_id, product_name, list_price
  FROM product.product
  ORDER BY list_price DESC

---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----

  SELECT B.store_id, A.product_name, A.list_price, B.quantity
  FROM product.product A
  INNER JOIN product.stock B
  ON A.product_id = B.product_id
  WHERE (store_id = 2) AND (quantity > 25)
  ORDER BY quantity DESC;

  /* other solution*/

  SELECT store_id, product_name, list_price, quantity
  FROM product.product as a, product.stock as b
  WHERE a.product_id=b.product_id and store_id=2 and quantity>25
  
---- 5. Find the sales order of the customers who lives in Boulder order by order date----

  SELECT A.customer_id, A.order_date, B.city
  FROM sale.orders A
  INNER JOIN sale.customer B
  ON A.customer_id = B.customer_id
  WHERE city = 'Boulder'
  ORDER BY order_date;

---- 6. Get the sales by staffs and years using the AVG() aggregate function.

  SELECT  A.staff_id, DATEPART(YEAR, A.order_date) AS order_year, COUNT(B.quantity) AS avg_quantity
  FROM sale.orders A
  INNER JOIN sale.order_item B
  ON A.order_id = B.order_id
  GROUP BY A.staff_id, DATEPART(YEAR, A.order_date)
  ORDER BY A.staff_id, DATEPART(YEAR, A.order_date)

  SELECT top 5 *
  FROM sale.order_item

  SELECT top 5 *
  FROM sale.orders

  SELECT A.staff_id, DATEPART(YEAR, A.order_date) AS order_year,ROUND(AVG(B.quantity*B.list_price*(1-B.discount)),2,1) AS avg_quantity
  FROM sale.orders A
  INNER JOIN sale.order_item B
  ON A.order_id = B.order_id
  GROUP BY A.staff_id, DATEPART(YEAR, A.order_date)
  ORDER BY A.staff_id, DATEPART(YEAR, A.order_date)

  
  SELECT A.staff_id, DATEPART(YEAR, A.order_date)
  FROM sale.orders A
  INNER JOIN sale.order_item B
  ON A.order_id = B.order_id
  WHERE A.staff_id = 2 AND DATEPART(YEAR, A.order_date) = 2018
  

---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----

  SELECT b.brand_name, SUM(c.quantity) AS brand_quantity
  FROM product.product A
  INNER JOIN product.brand B
  ON A.brand_id = B.brand_id
  INNER JOIN sale.order_item C
  ON A.product_id = c.product_id
  GROUP BY B.brand_name
  ORDER BY SUM(c.quantity) DESC

   SELECT top 5 *
  FROM product.product

  SELECT top 5 *
  FROM product.brand

  SELECT top 5 *
  FROM sale.order_item


---- 8. What are the categories that each brand has?----

  SELECT C.brand_name, B.category_name
  FROM product.product A
  LEFT JOIN product.category B
  ON A.category_id = B.category_id
  LEFT JOIN product.brand C
  ON A.brand_id = C.brand_id
  GROUP BY brand_name, category_name
  ORDER BY brand_name

  SELECT B.brand_name, C.category_name
  FROM product.product A
  JOIN product.brand B
  ON A.brand_id = B.brand_id
  JOIN product.category C
  ON A.category_id = C.category_id
  GROUP BY brand_name, category_name
  ORDER BY brand_name DESC


   SELECT top 5 *
  FROM product.category

  SELECT top 5 *
  FROM product.brand

  SELECT top 5 *
  FROM product.product


---- 9. Select the avg prices according to brands and categories----

select PB.brand_name, PC.category_name, AVG(PP.list_price) AS avg_list_price
from product.product PP
inner join product.brand PB
on PP.brand_id=PB.brand_id
inner join product.category PC
on PP.category_id=PC.category_id
group by  PC.category_name, PB.brand_name

   SELECT top 5 *
  FROM product.category

  SELECT top 5 *
  FROM product.brand

  SELECT top 5 *
  FROM product.product

  SELECT B.brand_name, C.category_name, SUM(A.list_price) / COUNT(B.brand_name)
  FROM product.product A
  JOIN product.brand B
  ON A.brand_id = B.brand_id
  JOIN product.category C
  ON A.category_id = C.category_id
  WHERE B.brand_name = 'Acer' AND C.category_name = 'Computer Accessories'
  GROUP BY B.brand_name, C.category_name


---- 10. Select the annual amount of product produced according to brands----

  SELECT A.model_year, B.brand_name, SUM(c.quantity) AS year_quantity
  FROM product.product A
  INNER JOIN product.brand B
  ON A.brand_id = B. brand_id
  INNER JOIN product.stock C
  ON A.product_id = C.product_id
  GROUP BY model_year, brand_name
  ORDER BY model_year DESC 

---- 11. Select the store which has the most sales quantity in 2016.----
  


---- 12 Select the store which has the most sales amount in 2018.----


---- 13. Select the personnel which has the most sales amount in 2019.----


















