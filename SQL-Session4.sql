
/* V�EW */

SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;

CREATE VIEW product_stock AS 
SELECT	A.product_id, A.product_name, B.store_id, B.quantity
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;

SELECT *   --�stteki create view komutu ile istenen tabloyu olu�turduk, alttaki sorguda da bu tablo g�r�n�m�n� �a��rd�k.
FROM dbo.product_stock
WHERE store_id = 1
;
--ORDER BY komutunu CREATE V�EW adl� tabloda kabul etmiyor, dbo.product_stock kulland���m�z yukardaki sorgudan sonra ORDER BY kullan�labilir.

----

-- Ma�aza �al��anlar�n� �al��t�klar� ma�aza bilgileriyle birlikte listeleyin
-- �al��an ad�, soyad�, ma�aza adlar�n� se�in

SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
ON	A.store_id = B.store_id
;

CREATE VIEW staff_names AS
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
ON	A.store_id = B.store_id
;

SELECT *
FROM dbo.staff_names
;

----

/* GROUP & AGGREGATION */


SELECT *
FROM product.brand
;

SELECT COUNT(*)
FROM product.brand
;

SELECT brand_id, COUNT(*)
FROM product.product
GROUP BY brand_id
;













