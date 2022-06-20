
--- WÝNDOW FUNCTÝONS ---

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

-- Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.

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

/*Window function ile oluþturduðunuz kolonlar birbirinden baðýmsýz hesaplanýr. 
Dolayýsýyla ayný select bloðu içinde farklý partitionlar tanýmlayarak yeni kolonlar oluþturabilirsiniz. */


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

-- Windows frame'i anlamak için birkaç güzel örnek:
-- Herbir satýrda iþlem yapýlacak olan frame'in büyüklüðünü(satýr sayýsýný) 
-- tespit edip window frame'in nasýl oluþtuðunu aþaðýdaki sorgu sonucuna göre konuþalým.

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
-- Herbir kategorideki en ucuz ürünün fiyatý?

SELECT DISTINCT category_id, MIN(list_price) OVER(PARTITION BY category_id) cheapest_cat
FROM product.product
;

---

-- How many different product in the product table?
-- Product tablosunda toplam kaç faklý product bulunduðu?

SELECT DISTINCT COUNT(*) OVER() num_of_product
FROM product.product
;

---

-- How many different product in the order_item table?
-- Order_item tablosunda kaç farklý ürün bulunmaktadýr?

SELECT DISTINCT product_id , 
	   COUNT(product_id) OVER(PARTITION BY product_id) num_of_product
FROM sale.order_item
;

SELECT COUNT(DISTINCT product_id) UniqueProduct
FROM sale.order_item
;

---

-- Write a query that returns how many different products are in each order?
-- Her sipariþte kaç farklý ürün olduðunu döndüren bir sorgu yazýn?

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
-- Herbir kategorideki herbir markada kaç farklý ürünün bulunduðu?

SELECT DISTINCT category_id, brand_id,
	   COUNT(*) OVER(PARTITION BY brand_id, category_id) CountofProduct
FROM product.product

SELECT DISTINCT category_id, brand_id, COUNT(*) CountofProduct
FROM product.product
GROUP BY category_id, brand_id
ORDER BY 1, 2

-- Eðer brand_name görmek istiyorsak;

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
--Bu çözüme bak!!!
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

---

-- 3rd Session --

-- Assign an ordinal number to the product prices for each category in ascending order
-- 1. Herbir kategori içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)


SELECT product_id, category_id, list_price,
	   ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) [row number]
FROM product.product
--ORDER BY 2,3

---

-- Ayný soruyu ayný fiyatlý ürünler ayný sýra numarasýný alacak þekilde yapýnýz (RANK fonksiyonunu kullanýnýz)

SELECT product_id, category_id, list_price,
	   ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) [row number],
	   RANK() OVER(PARTITION BY category_id ORDER BY list_price) [rank],
	   DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) [dense rank]
FROM product.product

---

-- 1. Herbir model_year içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)
-- row_number(), rank(), dense_rank()

SELECT product_id, model_year, list_price, 
	   ROW_NUMBER() OVER(PARTITION BY model_year ORDER BY list_price) [row number],
	   RANK() OVER(PARTITION BY model_year ORDER BY list_price) [rank],
	   DENSE_RANK() OVER(PARTITION BY model_year ORDER BY list_price) [dense rank]
FROM product.product

---

-- Write a query that returns the cumulative distribution of the list price in product table by brand.
-- Product tablosundaki list price' larýn kümülatif daðýlýmýný marka kýrýlýmýnda hesaplayýnýz

SELECT brand_id, list_price,
	   ROUND(CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price),3) CUM_DIST,
	   ROUND(PERCENT_RANK() OVER(PARTITION BY brand_id ORDER BY list_price),3) PER_RANK
	   --NTILE(100) OVER(PARTITION BY brand_id ORDER BY list_price) N_TILE
FROM product.product 

-- Yukarýdaki sorguda Cum_Dist alanýný CUME_DIST fonk. kullanmadan hesaplayýnýz.

-- CUME_DIST = ROW_NUMBER / TOTAL ROWS

SELECT brand_id, list_price,
	   COUNT(*) OVER(PARTITION BY brand_id) TotalProdBrand,
	   ROW_NUMBER() OVER(PARTITION BY brand_id ORDER BY list_price) RowNum,
	   RANK() OVER(PARTITION BY brand_id ORDER BY list_price) RankNum
FROM product.product

--- 

WITH tbl AS(
SELECT brand_id, list_price,
	   COUNT(*) OVER(PARTITION BY brand_id) TotalProdBrand,
	   ROW_NUMBER() OVER(PARTITION BY brand_id ORDER BY list_price) RowNum,
	   RANK() OVER(PARTITION BY brand_id ORDER BY list_price) RankNum
FROM product.product
)

SELECT *,
	   ROUND(CAST(RowNum AS FLOAT) / TotalProdBrand, 3) CumDistRowNum, --gelen deðerleri float deðerlere çevirebilmek için CAST ile FLOAT yaptýk ya da alt satýrda 1.0 ile çarptýk. 
	   ROUND(1.0 * RankNum / TotalProdBrand, 3) CumDistRankNum         --yoksa sonuçlar 1 ya da 0 olarak dönüyordu. ROUND ile de yuvarladýk. 
FROM tbl

---

-- Write a query that returns both of the followings:
-- The average product price of orders.
-- Average net amount.


-- Aþaðýdakilerin her ikisini de döndüren bir sorgu yazýn:
-- Sipariþlerde yer alan ürünlerin liste fiyatlarýnýn ortalamasý.
-- Tüm sipariþlerdeki ortalama net tutar.

SELECT order_id, 
	   AVG(list_price) OVER(PARTITION BY order_id) avg_price,
	   AVG(list_price * quantity * (1 - discount)) OVER() avg_net_amount
FROM sale.order_item 

/*
SELECT order_id, 
	   AVG(list_price) avg_price
FROM sale.order_item 
GROUP BY order_id, list_price
ORDER BY order_id
*/

---

--List orders for which the average product price is higher than the average net amount.
--Ortalama ürün fiyatýnýn ortalama net tutardan yüksek olduðu sipariþleri listeleyin.

WITH tbl AS(
SELECT DISTINCT order_id, 
	   AVG(list_price) OVER(PARTITION BY order_id) avg_price,
	   AVG(list_price * quantity * (1 - discount)) OVER() avg_net_amount
FROM sale.order_item 
)

SELECT *
FROM tbl
WHERE avg_price > avg_net_amount
ORDER BY avg_price

---

-- Calculate the stores weekly cumulative number of orders for 2018.
-- Maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz.

SELECT DISTINCT A.store_id, A.store_name,--B.order_date
	   DATEPART(ISO_WEEK, B.order_date) week_of_year,
	   COUNT(*) OVER(PARTITION BY A.store_id, DATEPART(ISO_WEEK, B.order_date)) weeks_order,
	   COUNT(*) OVER(PARTITION BY A.store_id ORDER BY DATEPART(ISO_WEEK, B.order_date)) cume_total_order
FROM sale.store A, sale.orders B
WHERE A.store_id = B.store_id AND 
	  YEAR(B.order_date) = 2018
ORDER BY 1, 3

---

-- Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
-- '2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.


--Her tarihteki toplam satýlan ürün miktarýný(quantity) bulduk.

SELECT B.order_date, SUM(A.quantity) sum_qauntity -- , A.order_id, A.product_id, A.quantity
FROM sale.order_item A, sale.orders B
WHERE A.order_id = B.order_id 
GROUP BY B.order_date
ORDER BY 1

-- 

WITH tbl AS(
SELECT B.order_date, SUM(A.quantity) sum_qauntity -- , A.order_id, A.product_id, A.quantity
FROM sale.order_item A, sale.orders B
WHERE A.order_id = B.order_id 
GROUP BY B.order_date
)

SELECT *,
	   AVG(sum_qauntity) OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) sales_moving_avg_7
FROM tbl 
WHERE order_date BETWEEN '2018-03-12' AND '2018-04-12'
ORDER BY 1

--hocanýn notlarýndan bu kýsým ile ilgili açýklamayý al!
























