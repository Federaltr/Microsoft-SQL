---- C-11 WEEKLY AGENDA-6 RD&SQL STUDENT

---- 1. List all the cities in the Texas and the numbers of customers in each city.----

  SELECT customer.customer_id, customer.city
  FROM sale.customer
  WHERE state = 'TX';

---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---

  SELECT customer.city, COUNT(customer_id) as customer_count
  FROM sale.customer
  WHERE state = 'CA'
  GROUP BY city
  ORDER BY COUNT(customer_id) DESC

---- 3. List the top 10 most expensive products----

  SELECT TOP 10 product_id, product_name, list_price
  FROM product.product
  ORDER BY list_price DESC

---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----

  SELECT B.store_id, A.product_name, A.list_price, B.quantity
  FROM product.product A
  LEFT JOIN product.stock B
  ON A.product_id = B.product_id
  WHERE (store_id = 2) AND (quantity > 25)
  ORDER BY quantity DESC;
  
---- 5. Find the sales order of the customers who lives in Boulder order by order date----

  SELECT A.customer_id, A.order_date, B.city
  FROM sale.orders A
  LEFT JOIN sale.customer B
  ON A.customer_id = B.customer_id
  WHERE city = 'Boulder'
  ORDER BY order_date;

---- 6. Get the sales by staffs and years using the AVG() aggregate function.

  SELECT  A.staff_id, DATEPART(YEAR, A.order_date) AS order_year, COUNT(B.quantity) AS avg_quantity
  FROM sale.orders A
  LEFT JOIN sale.order_item B
  ON A.order_id = B.order_id
  GROUP BY A.staff_id, DATEPART(YEAR, A.order_date)
  ORDER BY A.staff_id, DATEPART(YEAR, A.order_date)

---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----



---- 8. What are the categories that each brand has?----


---- 9. Select the avg prices according to brands and categories----


---- 10. Select the annual amount of product produced according to brands----


---- 11. Select the store which has the most sales quantity in 2016.----


---- 12 Select the store which has the most sales amount in 2018.----


---- 13. Select the personnel which has the most sales amount in 2019.----


















