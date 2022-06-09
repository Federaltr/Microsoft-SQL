
--- Assignment-2 ---

/* 
You need to create a report on whether customers who 
purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (first_product) --product_id = 13

2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product) --product_id = 16

3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)  --product_id = 21
*/


SELECT product_id, product_name
FROM product.product
WHERE product_name IN ('Polk Audio - 50 W Woofer - Black', 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'Virtually Invisible 891 In-Wall Speakers (Pair)')



SELECT d.customer_id, d.first_name, d.last_name,
	   a.product_name
FROM product.product a
JOIN sale.order_item b
ON a.product_id = b.product_id
JOIN sale.orders c
ON b.order_id = c.order_id
JOIN sale.customer d
ON c.customer_id = d.customer_id
GROUP BY d.customer_id, d.first_name, d.last_name, a.product_name 
;


CREATE VIEW name_customer_3 AS
SELECT d.customer_id, d.first_name, d.last_name,
	   a.product_name, a.product_id
FROM product.product a
JOIN sale.order_item b
ON a.product_id = b.product_id
JOIN sale.orders c
ON b.order_id = c.order_id
JOIN sale.customer d
ON c.customer_id = d.customer_id
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'  --product_id = 6
GROUP BY d.customer_id, d.first_name, d.last_name, a.product_name, a.product_id
;


SELECT *
FROM dbo.name_customer_3

---

SELECT *
FROM
			(
			SELECT customer_id, first_name, last_name, product_id
			FROM dbo.name_customer_3
			) A
PIVOT
(
	count(customer_id)
	FOR product_id IN
	(
	[13], [16], [21]
	)
) AS PIVOT_TABLE
;













