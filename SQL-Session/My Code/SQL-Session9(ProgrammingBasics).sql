
--- PROSEDURES ---


SELECT 'Hello world'

CREATE PROCEDURE sp_sampleproc1
AS
BEGIN

SELECT 'Hello world'

END
;

EXEC sp_sampleproc1;


---

DROP PROCEDURE sp_sampleproc1

---

ALTER PROCEDURE sp_sampleproc1
AS
BEGIN

SELECT 'Hello world 2'

END
;

EXEC sp_sampleproc1

---

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);

INSERT INTO ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )

SELECT *
FROM ORDER_TBL


CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);

SET NOCOUNT ON --verinin ka� sat�r oldu�um mesaj s�tununda g�r�ns�n istemiyorsak
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

SELECT *
FROM ORDER_DELIVERY

---

CREATE PROCEDURE sp_sum_order
AS 

BEGIN
	SELECT COUNT(*) AS total_order
	FROM ORDER_TBL
END
;

EXEC sp_sum_order

---

CREATE PROCEDURE sp_wantedday_order
	(
	@DAY DATE  --Parametre
	)
AS 

BEGIN
	SELECT COUNT(*) AS total_order
	FROM ORDER_TBL
	WHERE ORDER_DATE = @DAY
END
;

EXEC sp_wantedday_order '2022-06-22'

---

DECLARE 
	@p1 INT,
	@p2 INT,
	@SUM INT

SET @p1 = 5

SELECT *
FROM ORDER_TBL
WHERE ORDER_ID = @p1 
;


DECLARE
	@order_id INT,
	@customer_name nvarchar(100)

SET @order_id = 5

SELECT @customer_name = customer_name
from ORDER_TBL
where ORDER_ID = @order_id

select @customer_name

---

declare
	@day date

set @day = getdate()-2

EXECUTE sp_wantedday_order @day
;


--- FUNCTIONS ---

-- �nput olarak ald��� metni b�y�k harfe �eviren bir fonksiyon yazal�m

CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END
;

SELECT dbo.fnc_uppertext('hello world');

---

SELECT * FROM ORDER_TBL

--M��teri ad�n�n parametre olarak al�p ayn� m��terinin al��veri�ini d�nd�ren bir fonk. yaz�n�z.

CREATE FUNCTION fnc_getordersbycustomer
(
@CUSTOMER_NAME NVARCHAR(100)
)
RETURNS TABLE 
AS 

	RETURN
		SELECT * 
		FROM ORDER_TBL
		WHERE CUSTOMER_NAME = @CUSTOMER_NAME
;

SELECT *
FROM dbo.fnc_getordersbycustomer('Adam')

--e�er iki isim d�ns�n istersek;

??

ALTER FUNCTION fnc_getordersbycustomer
(
@CUSTOMER_NAME NVARCHAR(100)
)
RETURNS TABLE 
AS 

	RETURN
		SELECT * 
		FROM ORDER_TBL
		WHERE CUSTOMER_NAME IN (@CUSTOMER_NAME)
;

SELECT *
FROM dbo.fnc_getordersbycustomer('Adam', 'Owen')


--- IF/ ELSE ---

--Bir fonksiyon yaz�n�z. Ald��� rakamsal de�er �ift ise �ift, tek ise Tek e�er 0 ise S�f�r d�nd�rs�n.

DECLARE 
	@input INT,
	@modulus INT

SET @input = 5

SELECT @modulus = @input % 2

IF @input = 0
	BEGIN
	 PRINT 'S�f�r'
	END
ELSE IF @modulus = 0
	BEGIN
	 PRINT '�ift'
	END
ELSE PRINT 'Tek'

--

CREATE FUNCTION dbo.fnc_tekcift
(
	@input int
)
RETURNS NVARCHAR(max)
AS
BEGIN
	DECLARE
	 -- @input int,
		@modulus INT,
		@return NVARCHAR(max)
  --SET @input = 100
	SELECT @modulus = @input % 2
	IF @input = 0
		BEGIN
		 SET @return = 'S�f�r'
		END
	ELSE IF @modulus = 0
		BEGIN
		 SET @return = '�ift'
		END
	ELSE SET @return = 'Tek'

	RETURN @return
END
;

---

--- WHILE ---

-- 1'den 50'ye kadar say�lar� d�nd�ren bir fonksiyon yaz�n.

DECLARE 
	@counter INT,
	@total INT

SET @counter = 1
SET @total = 50

WHILE @counter <= @total
	BEGIN
		PRINT @counter
		SET @counter += 1
	END
;

---

/* 
Sipari�leri, tahmini teslim tarihleri ve ger�ekle�en teslim tarihlerini k�yaslayarak
'Late','Early' veya 'On Time' olarak s�n�fland�rmak istiyorum.
E�er sipari�in ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (ger�ekle�en teslimat tarihi) k���kse
Bu sipari�i 'LATE' olarak etiketlemek,
E�er EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipari�i 'EARLY' olarak etiketlemek,
E�er iki tarih birbirine e�itse de bu sipari�i 'ON TIME' olarak etiketlemek istiyorum.

Daha sonradan sipari�leri, sahip olduklar� etiketlere g�re farkl� i�lemlere tabi tutmak istiyorum.

istenilen bir order' �n status' unu tan�mlamak i�in bir scalar valued function olu�turaca��z.
��nk� girdimiz order_id, ��kt�m�z ise bir string de�er olan stat� olmas�n� bekliyoruz.
*/

DECLARE
	@input INT,
	@result NVARCHAR(100)
SET @input = 2
SELECT	@result =
		CASE
			WHEN B.DELIVERY_DATE < A.EST_DELIVERY_DATE
				THEN 'EARLY'
			WHEN B.DELIVERY_DATE > A.EST_DELIVERY_DATE
				THEN 'LATE'
			WHEN B.DELIVERY_DATE = A.EST_DELIVERY_DATE
				THEN 'ON TIME'
			ELSE NULL 
		END
FROM	ORDER_TBL A, ORDER_DELIVERY B
WHERE	A.ORDER_ID = B.ORDER_ID AND
		A.ORDER_ID = @input
;

SELECT @result

---

CREATE FUNCTION dbo.fnc_orderstatus
(
	@input INT
)
RETURNS NVARCHAR(max)
AS
BEGIN
	DECLARE
		@result NVARCHAR(100)
	-- SET @input = 1
	SELECT	@result =
				CASE
					WHEN B.DELIVERY_DATE < A.EST_DELIVERY_DATE
						THEN 'EARLY'
					WHEN B.DELIVERY_DATE > A.EST_DELIVERY_DATE
						THEN 'LATE'
					WHEN B.DELIVERY_DATE = A.EST_DELIVERY_DATE
						THEN 'ON TIME'
					ELSE NULL 
				END
	FROM	ORDER_TBL A, ORDER_DELIVERY B
	WHERE	A.ORDER_ID = B.ORDER_ID AND
			A.ORDER_ID = @input
	;
	RETURN @result
END
;

SELECT	dbo.fnc_orderstatus(3)
;

--t�m tabloya yazd�rd�.
SELECT	*, dbo.fnc_orderstatus(ORDER_ID) OrderStatus
FROM	ORDER_TBL
;


























