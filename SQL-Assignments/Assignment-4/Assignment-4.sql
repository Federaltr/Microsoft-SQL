
--- Assignment-4 ---

/*
Generate a report including product IDs and discount effects on whether the increase
in the discount rate positively impacts the number of orders for the products.

In this assignment, you are expected to generate a solution using SQL with a logical approach. 
*/


/*
Ýndirim oranýndaki artýþýn ürünler için sipariþ sayýsýný olumlu etkileyip 
etkilemediðine dair ürün kimliklerini ve indirim etkilerini içeren bir rapor oluþturun.

Bu ödevde mantýksal bir yaklaþýmla SQL kullanarak bir çözüm üretmeniz beklenmektedir.
*/


SELECT DISTINCT product_id, discount, 
	   SUM(quantity) OVER(PARTITION BY discount, product_id ORDER BY product_id) sum_quantity
INTO #Table
FROM sale.order_item

SELECT * FROM #Table

---

SELECT *,
	   FIRST_VALUE(sum_quantity) OVER(PARTITION BY product_id ORDER BY discount) first_value,
	   LAST_VALUE(sum_quantity) OVER(PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_value
INTO #Table2
FROM #Table

SELECT * FROM #Table2

--- SONUÇ

SELECT DISTINCT product_id,
	  CASE
		  WHEN last_value - first_value > 0 THEN 'Positive'
		  WHEN last_value - first_value < 0 THEN 'Negative'
		  ELSE 'Neutral'
	  END Discount_Effect
FROM #Table2

SELECT * FROM #Table

























