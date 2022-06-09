

--- SET OPERATORS ---

--- UNION ---

-- Charlotte þehrindeki müþteriler ile Aurora þehrindeki müþterilerin soyisimlerini listeleyin


SELECT last_name                 
FROM sale.customer
WHERE city = 'Charlotte'
UNION                  --UNION default olarak distinct sonuç döndürüyor ve order by ile sýralýyor.
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

-- Çalýþanlarýn ve müþterilerin e-posta adreslerini unique olacak þekilde listeleyiniz.


SELECT email
FROM sale.staff
UNION
SELECT email
FROM sale.customer


--- UNION ALL ---

SELECT last_name                 
FROM sale.customer
WHERE city = 'Charlotte'
UNION ALL                 
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'
ORDER BY last_name

--soyisim ve ismi 'Thomas' olan müþterileri sorgulayýnýz.


SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL                    --Unique olmadan tüm sonuçlarý getiriyor(not distinct)
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas'

--ya da

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas' OR last_name = 'Thomas'


--- INTERSECT ---

-- Write a query that returns brands that have products for both 2018 and 2019.


SELECT A.brand_id, b.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id AND
	  A.model_year = 2018
INTERSECT                         -- INTERSECT bize iki sorgudaki ortak sonucu verdi.
SELECT A.brand_id, b.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id AND
	  A.model_year = 2019


-- Write a query that returns customers who have orders for both 2018, 2019, and 2020.

SELECT A.first_name, A.last_name
FROM sale.customer A
JOIN sale.orders B
ON A.customer_id = B.customer_id
WHERE YEAR(B.order_date) = 2018
INTERSECT
SELECT A.first_name, A.last_name
FROM sale.customer A
JOIN sale.orders B
ON A.customer_id = B.customer_id
WHERE YEAR(B.order_date) = 2019
INTERSECT
SELECT A.first_name, A.last_name
FROM sale.customer A
JOIN sale.orders B
ON A.customer_id = B.customer_id
WHERE YEAR(B.order_date) = 2020


-- Charlotte ve Aurora þehrindeki müþterilerden soyadý ayný olanlarý listeleyiniz.

SELECT last_name                 
FROM sale.customer
WHERE city = 'Charlotte'
INTERSECT                
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'
ORDER BY last_name


select	*
from
	(
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2018
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A, sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2019
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2020
	) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date
;

--- EXCEPT ---

-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.


SELECT  A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE a.brand_id=b.brand_id AND A.model_year = 2018
EXCEPT							                  --2018'de olup 2019'da olmayan.
SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE a.brand_id=b.brand_id AND A.model_year = 2019;

--Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz.


SELECT C.product_id, D.product_name
FROM
	(
SELECT B.product_id
FROM sale.orders A, sale.order_item B
WHERE YEAR(A.order_date) = 2019 AND 
	  A.order_id = B.order_id
EXCEPT 
SELECT B.product_id
FROM sale.orders A, sale.order_item B
WHERE YEAR(A.order_date) != 2019 AND 
	  A.order_id = B.order_id
	) C, product.product D
WHERE C.product_id = D.product_id
;

-- Ýçerdeki sorguda yaptýðýmýz INTERSECT ile 2018 ve 2019'da ürünleri olan markalarý bulduk.
-- Except ile tüm ürünlerden çýkarýp hangi ürünlerin dahil olmadýðýný gördük. (5 farklý ürün)

select	brand_id, brand_name
from	product.brand
except
select	*
from	(
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2018
		INTERSECT
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2019
		) A


--- CASE EXPRESSION ---

--SimpleCase
SELECT order_id, order_status,
	   CASE order_status
		   WHEN 1 THEN 'Pending'
		   WHEN 2 THEN 'Processing'
		   WHEN 3 THEN 'Rejected'
		   WHEN 4 THEN 'Completed'
	   END order_status_desc
FROM sale.orders

--SearchedCase
SELECT order_id, order_status,
	   CASE 
		   WHEN order_status = 1 THEN 'Pending'
		   WHEN order_status = 2 THEN 'Processing'
		   WHEN order_status = 3 THEN 'Rejected'
		   WHEN order_status = 4 THEN 'Completed'
		   ELSE 'other'
	   END order_status_desc
FROM sale.orders

----

SELECT first_name, last_name, store_id,
	  CASE store_id
		  WHEN 1 THEN 'Davi Techno Retail'
		  WHEN 2 THEN 'The BFLO Store'
		  WHEN 3 THEN 'Burkes Outlet'
	  END store_name
FROM sale.staff
;

----

-- Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz.

SELECT first_name, last_name, email,
	  CASE
		  WHEN email LIKE '%@gmail%' THEN 'Gmail'
		  WHEN email LIKE '%@hotmail%' THEN 'Hotmail'
		  WHEN email LIKE '%@yahoo%' THEN 'Yahoo'
		  ELSE 'other'
	  END email_service_provider
FROM sale.customer
;

----

-- Ayný sipariþte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariþ veren müþterileri bulunuz.

SELECT C.first_name, C.last_name
FROM	(
		SELECT C.order_id, COUNT(DISTINCT A.category_id) unique_category
		FROM product.category A, product.product B, sale.order_item C
		WHERE A.category_name IN ('Computer Accessories', 'Speakers', 'mp4 player') AND
			  A.category_id = B.category_id AND
			  B.product_id = C.product_id
		GROUP BY C.order_id
		HAVING COUNT(DISTINCT A.category_id) = 3
		) A, sale.orders B, sale.customer C
WHERE A.order_id = B.order_id AND
	  B.customer_id = C.customer_id
;