
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

SELECT Count_of_Adv
FROM #CountAdv
WHERE Adv_Type = 'A'

SELECT Count_of_Adv
FROM #CountAdv
WHERE Adv_Type = 'B'

--

SELECT Action, Adv_Type, COUNT(Action) as Count_of_Action
INTO #CountAction
FROM CustomerAction
WHERE Action = 'Order'
GROUP BY Action, Adv_Type

SELECT Adv_Type, Count_of_Action
FROM #CountAction

SELECT Count_of_Action
FROM #CountAction 
WHERE Adv_Type = 'A'

SELECT Count_of_Action
FROM #CountAction 
WHERE Adv_Type = 'B'

--

SELECT Adv_Type, COUNT(Adv_Type) as Conversation_Rate
FROM CustomerAction
GROUP BY Adv_Type

SELECT Adv_Type, Count_of_Action
FROM #CountAction






