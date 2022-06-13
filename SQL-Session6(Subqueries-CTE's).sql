
 
--- SUBQUERIES(NESTED QUERIES) ---

-- In SELECT Clause

SELECT order_id,
	   list_price,
	   (
	   SELECT AVG(list_price)  -- t�m sat�rlar i�in ayn� de�er d�nd�.
	   FROM product.product
	   ) AS avg_price
FROM sale.order_item
;

-- In WHERE Clause

SELECT order_id, order_date
FROM sale.orders
WHERE order_date IN (
	                 SELECT TOP 5 order_date
					 FROM sale.orders
					 ORDER BY order_date DESC
                    )
;

SELECT TOP 5 order_id, order_date  --yukardaki kodla ayn� sonu�
FROM sale.orders
ORDER BY order_date  DESC

-- In FROM Clause

SELECT order_id, order_date
FROM	(
		 SELECT TOP 5 *
		 FROM sale.orders
		 ORDER BY order_date DESC
		) A  --Alias olmadan �al��m�yor e�er tablo tan�mlarsak.
;

----

--Write query that returnsthe total list price by each order ids.

SELECT order_id, SUM(list_price) AS total_price
FROM sale.order_item
GROUP BY order_id
;

--with subquery

SELECT so.order_id,
	   (
	   SELECT SUM(list_price)
	   FROM sale.order_item
	   WHERE order_id = so.order_id
	   ) AS sum_price
FROM sale.order_item so
GROUP BY so.order_id

---

-- Davis Thomas'n�n �al��t��� ma�azadaki t�m personelleri listeleyin.

SELECT *
FROM sale.staff
WHERE store_id = (
				  SELECT store_id
				  FROM sale.staff
				  WHERE first_name = 'Davis' and last_name = 'Thomas'
				 )
;

----

-- Charles	Cussona '�n y�neticisi oldu�u personelleri listeleyin.

SELECT *
FROM sale.staff
WHERE first_name = 'Charles' AND last_name = 'Cussona' 

SELECT *
FROM sale.staff 
WHERE manager_id = (
					SELECT staff_id
					FROM sale.staff
					WHERE first_name = 'Charles' AND last_name = 'Cussona' 
					)
;

----

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli �r�nden pahal� olan �r�nleri listeleyin.
-- Product id, product name, model_year, fiyat, marka ad� ve kategori ad� alanlar�na ihtiya� duyulmaktad�r. 

SELECT *
FROM product.product
WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'


SELECT product_id, product_name, model_year, list_price
FROM product.product
WHERE list_price > (
					SELECT list_price
					FROM product.product
					WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
					)
;

----

--List all customers who orders on the same date as Laurel Goldammer.

SELECT 
FROM sale.orders A
JOIN sale.customer B
ON A.customer_id = B.customer_id
WHERE first_name = 'Laurel' AND last_name = 'Goldammer'

SELECT B.first_name, B.last_name, A.order_date
FROM sale.orders A
JOIN sale.customer B
ON A.customer_id = B.customer_id
WHERE order_date IN
				   (
                    SELECT A.order_date
					FROM sale.orders A
					JOIN sale.customer B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Laurel' AND last_name = 'Goldammer'
				   )
;

----

--List products made in 2021 and their categories other than Game, GPS, or Home Theater.

SELECT A.product_name, A.list_price
FROM product.product A, product.category B
WHERE A.category_id = B.category_id
AND A.model_year = 2021
AND B.category_name NOT IN ('Game', 'GPS', 'Home Theater')

----

-- Model y�l� 2020 olan ve Receivers Amplifiers kategorisindeki en pahal� �r�nden daha pahal� �r�nleri listeleyin.
-- �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z.

SELECT TOP 1 *  
FROM product.product A, product.category B
WHERE A.category_id = B.category_id 
	  AND B.category_name = 'Receivers Amplifiers' 
ORDER BY A.list_price DESC

SELECT product_name, model_year, list_price
FROM product.product 
WHERE model_year = 2020
	  AND list_price > (  --Single row subquery
						SELECT TOP 1 A.list_price
						FROM product.product A, product.category B
						WHERE A.category_id = B.category_id 
							  AND B.category_name = 'Receivers Amplifiers' 
						ORDER BY A.list_price DESC
					    )
ORDER BY list_price DESC
;

--Another Solution(Multiple row subquery-(ALL))

select	product_name, model_year, list_price
from	product.product
where	model_year = 2020 and
		list_price > ALL (    --ALL kulland���m�zda birden �ok sat�r d�nd�ren nested ifadedeki her sat�r� kontrol eder.
			select	B.list_price
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			         )
order by 3 DESC
;

----

-- Model y�l� 2020 olan ve Receivers Amplifiers kategorisindeki herhangi bir �r�nden daha pahal� �r�nleri listeleyin.
-- �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z.

SELECT TOP 1 *
FROM product.product A, product.category B
WHERE A.category_id = B.category_id 
	  AND B.category_name = 'Receivers Amplifiers' 
ORDER BY A.list_price 

SELECT product_name, model_year, list_price
FROM product.product 
WHERE model_year = 2020
	  AND list_price > (  --Single row subquery
						SELECT TOP 1 A.list_price
						FROM product.product A, product.category B
						WHERE A.category_id = B.category_id 
							  AND B.category_name = 'Receivers Amplifiers' 
						ORDER BY A.list_price 
					    )
ORDER BY list_price DESC
;

-- Another Solution(Multiple row subquery-(ANY))

select	product_name, model_year, list_price
from	product.product
where	model_year = 2020 and
		list_price > ANY ( 
			select	B.list_price
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' 
					and	A.category_id = B.category_id
					)
order by 3 DESC
;

--- 

-- Correlated Subqueries --
--- EX�ST/NOT EX�ST --- 

-- Apple - Pre-Owned iPad 3 - 32GB - White �r�n�n hi� sipari� verilmedi�i eyaletleri bulunuz.
-- Eyalet m��terilerin ikamet adreslerinden al�nacakt�r.

-- 'Apple - Pre-Owned iPad 3 - 32GB - White'

SELECT *
FROM product.product
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'

SELECT DISTINCT C.state  --�r�n� sat�n alanlar�n eyaletlerini getirir.
FROM product.product P, 
	 sale.order_item I,
	 sale.orders O,
	 sale.customer C
WHERE P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND
      P.product_id = I.product_id AND 
	  I.order_id = O.order_id AND 
	  O.customer_id = C.customer_id
;

SELECT DISTINCT [state]
FROM sale.customer C2
WHERE NOT EXISTS (SELECT 1
   				  FROM product.product P, 
					   sale.order_item I,
					   sale.orders O,
					   sale.customer C
				  WHERE P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND
					   P.product_id = I.product_id AND 
					   I.order_id = O.order_id AND 
					   O.customer_id = C.customer_id AND
					   C2.[state] = C.[state]
				)
;

---

-- Burkes Outlet ma�aza sto�unda bulunmay�p,
-- Davi techno ma�azas�nda bulunan �r�nlerin stok bilgilerini d�nd�ren bir sorgu yaz�n. (edited) 

SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
	NOT EXISTS ( SELECT DISTINCT A.product_id, A.store_id, A.quantity
				 FROM product.stock A, sale.store B
				 WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND
				       PC.product_id = A.product_id AND A.quantity>0
	           )
;

SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
	 EXISTS ( SELECT DISTINCT A.product_id, A.store_id, A.quantity
			  FROM product.stock A, sale.store B
			  WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND
				    PC.product_id = A.product_id AND A.quantity=0
	         )
;

---

-- Burkes Outlet'den al�n�p The BFLO Store'dan hi� al�nmayan �r�n var m�?
-- Varsa bu �r�nler nelerdir?
-- �r�nlerin sat�� bilgileri istenmiyor, sadece �r�n listesi isteniyor.

SELECT DISTINCT P.product_name
FROM product.product P,
     sale.order_item I,
     sale.orders O,
     sale.store S
WHERE store_name = 'Burkes Outlet'
    AND P.product_id = I.product_id
    AND I.order_id = O.order_id
    AND O.store_id = S.store_id
    AND NOT EXISTS (SELECT PP.product_name
                    FROM product.product PP,
                        sale.order_item SI,
                        sale.orders SO,
                        sale.store SS
                    WHERE store_name = 'The BFLO Store'
                        AND PP.product_id = SI.product_id
                        AND SI.order_id = SO.order_id
                        AND SO.store_id = SS.store_id
                        AND P.product_name = PP.product_name)
;

---

--- CTE's (Common Table Expressions) ---

-- Jerald Berray isimli m��terinin son sipari�inden �nce sipari� vermi� 
-- ve Austin �ehrinde ikamet eden m��terileri listeleyin.

  WITH tbl AS (
				SELECT max(B.order_date) JeraldLastOrderDate
				FROM sale.customer A, sale.orders B
				WHERE A.first_name = 'Jerald' AND A.last_name = 'Berray'
				  AND A.customer_id = B.customer_id
			   )
			   
SELECT DISTINCT A.first_name, A.last_name
FROM sale.customer A, 
	 sale.orders B,
	 tbl C
WHERE A.city = 'Austin' 
  AND A.customer_id = B.customer_id		
  AND B.order_date < C.JeraldLastOrderDate
;
			   
---

-- Herbir markan�n sat�ld��� en son tarihi bir CTE sorgusunda,
-- Yine herbir markaya ait ka� farkl� �r�n bulundu�unu da ayr� bir CTE sorgusunda tan�mlay�n�z.
-- Bu sorgular� kullanarak  Logitech ve Sony markalar�na ait son sat�� tarihini ve toplam �r�n say�s�n� (product tablosundaki) ayn� sql sorgusunda d�nd�r�n�z.


WITH tbl AS(
	SELECT	br.brand_id, br.brand_name, MAX(so.order_date) LastOrderDate
	FROM	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	WHERE	so.order_id = soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	GROUP BY br.brand_id, br.brand_name
),
tbl2 AS(
	SELECT	pb.brand_id, pb.brand_name, COUNT(*) count_product
	FROM	product.brand pb, product.product pp
	WHERE	pb.brand_id = pp.brand_id
	GROUP BY pb.brand_id, pb.brand_name
)
SELECT	*
FROM	tbl a, tbl2 b
WHERE	a.brand_id = b.brand_id AND
		a.brand_name in ('Logitech', 'Sony')
;

---

-- RECURS�VE CTE

-- 0'dan 9'a kadar herbir rakam bir sat�rda olacak �ekide bir tablo olu�turun.

WITH cte AS (
	     SELECT 0 rakam
		 UNION ALL
		 SELECT rakam + 1
		 FROM cte
		 WHERE rakam < 9
		    )

SELECT * FROM cte

---

-- 2020 ocak ay�n�n herbir tarihi bir sat�r olacak �ekilde 31 sat�rl� bir tablo olu�turunuz.

WITH ocak AS (
		  SELECT CAST('2020-01-01' AS DATE) tarih
		  UNION ALL
		  SELECT DATEADD(DAY, 1, tarih)
		  FROM ocak
		  WHERE tarih < EOMONTH('2020-01-01')
		     )

SELECT * FROM ocak

---

-- Write a query that returns all staff with their manager_ids. (use recursive CTE)

SELECT staff_id, first_name, manager_id
FROM sale.staff

with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte
;

---

-- 2018 y�l�nda t�m ma�azalar�n ortalama cirosunun alt�nda ciroya sahip ma�azalar� listeleyin.
-- List the stores their earnings are under the average income in 2018.

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;





