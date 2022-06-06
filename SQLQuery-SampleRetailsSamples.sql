  
  /* örnek çözümler */
  
  ---- (LEFT AND INNER)

  SELECT product_name, order_id
  FROM product.product
  LEFT JOIN sale.order_item
  ON product.product_id = order_item.product_id
  WHERE brand_id = 14
  ORDER BY order_id ASC;

  ----

  SELECT A.product_id, A.product_name, 
		 B.category_id, B.category_name
  FROM product.product A
  LEFT JOIN product.category B
  ON A.category_id = B.category_id;
  
  ----

  SELECT A.first_name, A.last_name, B.store_name
  FROM sale.staff A
  INNER JOIN sale.store B
  ON A.store_id = B.store_id;

  ----

  SELECT T.product_id, T.product_name, C.order_id
  FROM product.product T
  LEFT JOIN sale.order_item C
  ON T.product_id = C.product_id 
  WHERE C.order_id IS NULL;

  ----

  SELECT A.product_id, A.product_name, 
		 B.store_id, B.product_id, B.quantity 
  FROM product.product A
  LEFT JOIN product.stock B
  ON A.product_id = B.product_id
  WHERE A.product_id > 310 
  ORDER BY A.product_id DESC;

  ---- (RIGHT) 

  SELECT B.product_id, B.product_name, 
		 A.*
  FROM product.stock A
  RIGHT JOIN product.product B
  ON A.product_id = B.product_id
  WHERE B.product_id > 310;

  ---- (FULL OUTER)

  SELECT TOP 100  A.product_id, 
				  B.store_id, B.quantity,
				  C.order_id, C.list_price
  FROM product.product A
  FULL OUTER JOIN product.stock B
  ON A.product_id = B.product_id
  FULL OUTER JOIN sale.order_item C
  ON A.product_id = C.product_id 
  ORDER BY B.store_id;

  ---- (CROSS)

  --stock tablosunda olmayýp product tablosunda mevcut olan ürünlerin stock tablosuna tüm storelar için kayýt edilmesi gerekiyor. 
  --stoðu olmadýðý için quantity'leri 0 olmak zorunda
  --Ve bir product_id tüm store'larýn stock'una eklenmesi gerektiði için cross join yapmamýz gerekiyor.

  SELECT	B.store_id, A.product_id, 0 quantity
  FROM	product.product A
  CROSS JOIN sale.store B
  WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
  ORDER BY A.product_id, B.store_id;











