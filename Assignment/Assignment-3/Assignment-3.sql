
--- Assignment-3 ---

/*
a. Create above table (Actions) and insert values,
b. Retrieve count of total Actions and Orders for each Advertisement Type,
c. Calculate Orders (Conversion) rates for each Advertisement Type 
   by dividing by total count of actions casting as float by multiplying by 1.0.
*/

-- Tablo Oluþturma

CREATE TABLE CustomerAction (
	Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY,
	Adv_Type VARCHAR (5) NOT NULL,
	[Action] VARCHAR (25) NOT NULL
);

-- Tabloya Veri Ekleme

SET IDENTITY_INSERT CustomerAction ON;

INSERT INTO CustomerAction (Visitor_ID, Adv_Type, [Action])
VALUES
(1, 'A', 'Left'),
(2, 'A', 'Order'),
(3, 'B', 'Left'),
(4, 'A', 'Order'),
(5, 'A', 'Review'),
(6, 'A', 'Left'),
(7, 'B', 'Left'),
(8, 'B', 'Order'),
(9, 'B', 'Review'),
(10, 'A', 'Review')

SET IDENTITY_INSERT CustomerAction OFF;
GO

SELECT *
FROM CustomerAction

-- 

SELECT Adv_Type, COUNT(Adv_Type) AS Count_of_Adv
INTO #CountAdv
FROM CustomerAction
GROUP BY Adv_Type

SELECT *
FROM #CountAdv

--

SELECT Action, Adv_Type, COUNT(Action) as Count_of_Action
INTO #CountAction
FROM CustomerAction
WHERE Action = 'Order'
GROUP BY Action, Adv_Type

SELECT Adv_Type, Count_of_Action
FROM #CountAction


-- Sonuç

SELECT A.Adv_Type, A.Count_of_Adv, B.Count_of_Action
INTO #Last_table
FROM #CountAdv A
JOIN #CountAction B
ON A.Adv_Type = B.Adv_Type

SELECT * FROM #Last_table

SELECT Adv_Type, CAST((Count_of_Action*1.0/Count_of_Adv) AS NUMERIC(3,2)) as Conversion_Rate  --Numeric yerine Decimal'de kullanýlabilir.(Float deðer olmasý ve bölünebilmesi için 1.0 ile çarptýk.)
FROM #Last_table


-- Another Solution With CTE's

WITH CTE1 AS
(
SELECT adv_type, 
		COUNT (*) total_action
FROM	#T1
GROUP BY adv_type
), CTE2 AS
(
SELECT adv_type, COUNT (*) order_action
FROM	#T1
WHERE action = 'Order'
GROUP BY adv_type
)
SELECT	CTE1.adv_type, CTE1.total_action, CTE2.order_action, cast(1.0*order_action/total_action as decimal(3,2)) AS conversion_rate
FROM	CTE1, CTE2
WHERE	CTE1.adv_type = CTE2.adv_type




