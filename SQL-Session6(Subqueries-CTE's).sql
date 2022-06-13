
 
--- SUBQUERIES(NESTED QUERIES) ---

-- In SELECT Clause

SELECT order_id,
	   list_price,
	   (
	   SELECT AVG(list_price)  -- tüm satýrlar için ayný deðer döndü.
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

SELECT TOP 5 order_id, order_date  --yukardaki kodla ayný sonuç
FROM sale.orders
ORDER BY order_date  DESC

-- In FROM Clause

SELECT order_id, order_date
FROM	(
		 SELECT TOP 5 *
		 FROM sale.orders
		 ORDER BY order_date DESC
		) A  --Alias olmadan çalýþmýyor eðer tablo tanýmlarsak.
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

-- Davis Thomas'nýn çalýþtýðý maðazadaki tüm personelleri listeleyin.

SELECT *
FROM sale.staff
WHERE store_id = (
				  SELECT store_id
				  FROM sale.staff
				  WHERE first_name = 'Davis' and last_name = 'Thomas'
				 )
;

----

-- Charles	Cussona 'ýn yöneticisi olduðu personelleri listeleyin.

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

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr. 

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

-- Model yýlý 2020 olan ve Receivers Amplifiers kategorisindeki en pahalý üründen daha pahalý ürünleri listeleyin.
-- Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.

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
		list_price > ALL (    --ALL kullandýðýmýzda birden çok satýr döndüren nested ifadedeki her satýrý kontrol eder.
			select	B.list_price
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			         )
order by 3 DESC
;

----

-- Model yýlý 2020 olan ve Receivers Amplifiers kategorisindeki herhangi bir üründen daha pahalý ürünleri listeleyin.
-- Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.

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
--- EXÝST/NOT EXÝST --- 

-- Apple - Pre-Owned iPad 3 - 32GB - White ürünün hiç sipariþ verilmediði eyaletleri bulunuz.
-- Eyalet müþterilerin ikamet adreslerinden alýnacaktýr.

-- 'Apple - Pre-Owned iPad 3 - 32GB - White'

SELECT *
FROM product.product
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'

SELECT DISTINCT C.state  --ürünü satýn alanlarýn eyaletlerini getirir.
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

-- Burkes Outlet maðaza stoðunda bulunmayýp,
-- Davi techno maðazasýnda bulunan ürünlerin stok bilgilerini döndüren bir sorgu yazýn. (edited) 

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

-- Burkes Outlet'den alýnýp The BFLO Store'dan hiç alýnmayan ürün var mý?
-- Varsa bu ürünler nelerdir?
-- Ürünlerin satýþ bilgileri istenmiyor, sadece ürün listesi isteniyor.

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

-- Jerald Berray isimli müþterinin son sipariþinden önce sipariþ vermiþ 
-- ve Austin þehrinde ikamet eden müþterileri listeleyin.

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

-- Herbir markanýn satýldýðý en son tarihi bir CTE sorgusunda,
-- Yine herbir markaya ait kaç farklý ürün bulunduðunu da ayrý bir CTE sorgusunda tanýmlayýnýz.
-- Bu sorgularý kullanarak  Logitech ve Sony markalarýna ait son satýþ tarihini ve toplam ürün sayýsýný (product tablosundaki) ayný sql sorgusunda döndürünüz.


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

-- RECURSÝVE CTE

-- 0'dan 9'a kadar herbir rakam bir satýrda olacak þekide bir tablo oluþturun.

WITH cte AS (
	     SELECT 0 rakam
		 UNION ALL
		 SELECT rakam + 1
		 FROM cte
		 WHERE rakam < 9
		    )

SELECT * FROM cte

---

-- 2020 ocak ayýnýn herbir tarihi bir satýr olacak þekilde 31 satýrlý bir tablo oluþturunuz.

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

-- 2018 yýlýnda tüm maðazalarýn ortalama cirosunun altýnda ciroya sahip maðazalarý listeleyin.
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





