
--- Assignment-2 ---

/* 
You need to create a report on whether customers who 
purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (first_product) --product_id = 13

2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product) --product_id = 16

3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)  --product_id = 21
*/



SELECT DISTINCT d.customer_id, d.first_name, d.last_name,  
	   a.product_name
INTO #main_table
FROM product.product a
JOIN sale.order_item b
ON a.product_id = b.product_id
JOIN sale.orders c
ON b.order_id = c.order_id
JOIN sale.customer d
ON c.customer_id = d.customer_id
--GROUP BY d.customer_id, d.first_name, d.last_name, a.product_name 
;

SELECT * FROM #main_table    -- Tüm ürünleri içeren customer tablosu.

---

SELECT DISTINCT * 
INTO #hdd_table
FROM #main_table
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

SELECT * FROM #hdd_table  --'2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' bu ürünü alanlarýn tablosu.

---

SELECT DISTINCT *
INTO #woofer_table
FROM #main_table
WHERE product_name = 'Polk Audio - 50 W Woofer - Black'  

SELECT * FROM #woofer_table  -- istenen (first_product) tablosu

---

SELECT DISTINCT *
INTO #subwoofer_table
FROM #main_table
WHERE product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'

SELECT * FROM #subwoofer_table  -- istenen (second_product) tablosu

---

SELECT DISTINCT *
INTO #speakers_table
FROM #main_table
WHERE product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)' 

SELECT * FROM #speakers_table  -- istenen (third_product) tablosu

---

SELECT HT.*, WT.product_name first_product, 
             ST.product_name second_product, 
			 SPT.product_name third_product
INTO #last_tablee
FROM #hdd_table HT
LEFT JOIN #woofer_table WT
ON HT.customer_id = WT.customer_id
LEFT JOIN #subwoofer_table ST
ON HT.customer_id = ST.customer_id
LEFT JOIN #speakers_table SPT
ON HT.customer_id = SPT.customer_id

SELECT * FROM #last_tablee

---

SELECT customer_id, first_name, last_name,
	  REPLACE(ISNULL(first_product, 'No'), 'Polk Audio - 50 W Woofer - Black', 'Yes') First_product,
	  REPLACE(ISNULL(second_product, 'No'), 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'Yes') Second_product,
	  REPLACE(ISNULL(third_product, 'No'), 'Virtually Invisible 891 In-Wall Speakers (Pair)', 'Yes') Third_product
FROM #last_tablee