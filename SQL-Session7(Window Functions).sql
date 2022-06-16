
--- W�NDOW FUNCT�ONS ---

-- Write a query that returns stock amounts of products(only stock table)
-- (Use both of Group By and WF)

-- with GROUP BY 

SELECT product_id, SUM(quantity) as total_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id
;

-- with WF 
SELECT *, SUM(quantity) OVER(PARTITION BY product_id) total_stock
FROM product.stock
ORDER BY product_id


SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id) total_stock
FROM product.stock
ORDER BY product_id

---

-- Markalara g�re ortalama �r�n fiyatlar�n� hem Group By hem de Window Functions ile hesaplay�n�z.

-- with GROUP BY

SELECT brand_id, AVG(list_price) as avg_price
FROM product.product
GROUP BY brand_id

-- with WF 

SELECT DISTINCT brand_id, AVG(list_price) OVER(PARTITION BY brand_id) as avg_price
FROM product.product

---

SELECT *,
	   COUNT(*) OVER(PARTITION BY brand_id) countofproduct,
	   MAX(list_price) OVER(PARTITION BY brand_id) maxlistprice
FROM product.product
ORDER BY brand_id, product_id


SELECT *,
	   COUNT(*) OVER(PARTITION BY brand_id) countofproduct,
	   COUNT(*) OVER(PARTITION BY category_id) countofproductincategory
FROM product.product
ORDER BY brand_id, product_id

/*Window function ile olu�turdu�unuz kolonlar birbirinden ba��ms�z hesaplan�r. 
Dolay�s�yla ayn� select blo�u i�inde farkl� partitionlar tan�mlayarak yeni kolonlar olu�turabilirsiniz. */


SELECT product_id, brand_id, category_id, model_year,
	   COUNT(*) OVER(PARTITION BY brand_id) CountOfProductinBrand,
	   COUNT(*) OVER(PARTITION BY category_id) CountOfProductinCategory
FROM product.product
ORDER BY category_id, brand_id, model_year
;

SELECT DISTINCT brand_id, category_id, model_year,
	   COUNT(*) OVER(PARTITION BY brand_id) CountOfProductinBrand,
	   COUNT(*) OVER(PARTITION BY category_id) CountOfProductinCategory
FROM product.product
ORDER BY category_id, brand_id, model_year
;

---

/*

WF SYNTAX

SELECT {columns},
FUNCTION() OVER(PARTITION BY ... ORDER BY ... WINDOW FRAME)
FROM table1;

*/


-- Window Frames

-- Windows frame'i anlamak i�in birka� g�zel �rnek:
-- Herbir sat�rda i�lem yap�lacak olan frame'in b�y�kl���n�(sat�r say�s�n�) 
-- tespit edip window frame'in nas�l olu�tu�unu a�a��daki sorgu sonucuna g�re konu�al�m.

--DEFAULT : UNBOUNDED PRECEDING AND CURRENT ROW

SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id
;

---

-- Cheapest product price in each category?
-- Herbir kategorideki en ucuz �r�n�n fiyat�?

SELECT DISTINCT category_id, MIN(list_price) OVER(PARTITION BY category_id) cheapest_cat
FROM product.product
;

---

-- How many different product in the product table?
-- Product tablosunda toplam ka� fakl� product bulundu�u?

SELECT DISTINCT COUNT(*) OVER() num_of_product
FROM product.product
;

---

-- How many different product in the order_item table?
-- Order_item tablosunda ka� farkl� �r�n bulunmaktad�r?

SELECT DISTINCT product_id , 
	   COUNT(product_id) OVER(PARTITION BY product_id) num_of_product
FROM sale.order_item
;

SELECT COUNT(DISTINCT product_id) UniqueProduct
FROM sale.order_item
;

---

-- Write a query that returns how many different products are in each order?
-- Her sipari�te ka� farkl� �r�n oldu�unu d�nd�ren bir sorgu yaz�n?

-- with GROUP BY

SELECT order_id, COUNT(DISTINCT product_id) UniqueProduct,
	   SUM(quantity) TotalProduct
FROM sale.order_item
GROUP BY order_id
;


-- with WF

SELECT DISTINCT order_id,
	   COUNT(product_id) OVER(PARTITION BY order_id) UniqueProduct,
	   SUM(quantity) OVER(PARTITION BY order_id) TotalProduct
FROM sale.order_item
;

---

-- How many different product are in each brand in each category?
-- Herbir kategorideki herbir markada ka� farkl� �r�n�n bulundu�u?

SELECT DISTINCT category_id, brand_id,
	   COUNT(*) OVER(PARTITION BY brand_id, category_id) CountofProduct
FROM product.product

SELECT DISTINCT category_id, brand_id, COUNT(*) CountofProduct
FROM product.product
GROUP BY category_id, brand_id
ORDER BY 1, 2

-- E�er brand_name g�rmek istiyorsak;

SELECT DISTINCT A.category_id, A.brand_id,
	   COUNT(*) OVER(PARTITION BY A.brand_id, category_id) CountofProduct,
	   B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id 

-- 2nd Session --

-- Write aquery that returns most stocked product in each store

SELECT DISTINCT store_id,
	   FIRST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity DESC) most_stocked_prod 
FROM product.stock


-- Write a query that returns customer and their most valuable order with total amount of it.
--Bu ��z�me bak!!!
SELECT DISTINCT customer_id,
	   FIRST_VALUE(A.order_id) OVER(PARTITION BY customer_id ORDER BY SUM(B.list_price * B.quantity * (1 - B.discount)) DESC )orders,
	   FIRST_VALUE(SUM(B.list_price * B.quantity * (1 - B.discount))) OVER(PARTITION BY customer_id ORDER BY SUM(B.list_price * B.quantity * (1 - B.discount))DESC ) orders2
FROM sale.orders A, sale.order_item B
WHERE A.order_id = B.order_id 

-- Another Solution

SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
ORDER BY 1,3 DESC;
WITH T1 AS
(
SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
)
SELECT	DISTINCT customer_id,
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MV_ORDER,
		FIRST_VALUE(net_price) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MVORDER_NET_PRICE
FROM	T1

---

-- Write a query taht returns first order date by month.

SELECT DISTINCT YEAR(order_date) [Year], 
	   MONTH(order_date) [Month], 
	   FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_order_date
FROM sale.orders

---

-- Write aquery that returns most stocked product in each store

SELECT DISTINCT store_id,
	   FIRST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity DESC) most_stocked_prod 
FROM product.stock

SELECT DISTINCT store_id,
	  LAST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity ASC, product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) most_stocked_prod 
FROM product.stock

---

--

SELECT order_id, staff_id, first_name, last_name, order_date,
	   LAG(order_date) OVER(PARTITION BY staff_id ORDER BY order_id) prev_order_date
FROM sale.orders A, sale.customer B
WHERE A.customer_id = B.customer_id

SELECT order_id, staff_id, first_name, last_name, order_date,
	   LEAD(order_date) OVER(PARTITION BY staff_id ORDER BY order_id) next_order_date
FROM sale.orders A, sale.customer B
WHERE A.customer_id = B.customer_id















