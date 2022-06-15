
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









