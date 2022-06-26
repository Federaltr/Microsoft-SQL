
/*

PostCodes.csv dosyas� 4 s�tundan olu�maktad�r.

1. Postcode: 4 haneli posta kodu numaras�
2. PostcodeName: Posta kodunun ad� (o b�lgenin ad�)
3. ValidFrom: Hangi tarihten itibaren ge�erli oldu�u
4. ValidTo: Hangi tarihe kadar ge�erli oldu�u

Bir posta kodu kapat�labilir.
Belli bir s�re ask�ya al�nabilir.
Bir posta kodunun ad� de�i�ebilir.

Ayn� g�n kapan�p ayn� g�n yeniden a��lan ve ad� de�i�memi� posta kodlar� ayn� posta kodu olarak kabul edilir.
Hangi g�n kapan�p hangi g�n a��l�rsa a��ls�n bir posta kodunun ad� de�i�mi�se bu durumda eski posta kodu kapanm�� say�l�r. 
Yeni isimli posta kodu ise ilk defa a��lm�� farkl� bir posta kodudur.
Ayn� tarihte bir posta kodunun iki farkl� ad� olamaz.
ValidTo s�tunu bo� olan kay�tlar postakodunun halen ge�erli oldu�unu anlam�na gelir.

E�er bir posta kodunun ad� de�i�memi�se ve ask�ya al�nma tarihi ile ayn� posta kodunun yeniden a��lma tarihleri ayn� ise bu sat�rlar�n tek bir sat�rda toplanmas� gerekmektedir.

Postcode	PostcodeName	ValidFrom	ValidTo
1		A		01.01.1999	01.02.1999
1		A		01.02.1999	

�rne�in yukar�daki �rnekte 1 numaral� Postkodu 1 Ocak 1999 tarihinde a��lm�� ve 1 �ubat 1999 tarihinde kapat�lm��. 
Fakat ayn� g�n ayn� posta numaras� ayn� isimle yeniden a��lm�� ve halen de ge�erli bir posta kodu. Dolay�s�yla bu iki sat�r birle�tirilecektir ve a�a��daki �ekilde tutulacakt�r:

Postcode	PostcodeName	ValidFrom	ValidTo
1		A		01.01.1999

E�er bu �rnekte 2. sat�rda yer alan posta kodu ayn� g�n de�il de daha sonra a��lm�� olsayd� bu durumda ikinci kay�t yeni bir postakodu gibi d���nelecektir. Ve bu iki sat�r birle�tirilmeyecektir.

Bir ba�ka �rnek vermek gerekirse Postcode: 1 in ad�n�n ilk �nce A sonra B oldu�unu varsayal�m. 
Bu durumda B isimli posta kodunun a��ld��� tarih A isimli posta kodunun kapand��� tarihe e�it de olsa farkl� da olsa bu posta kodu yeni bir posta kodu olup bu tip durumlarda da sat�rlar birle�tirilmeyecektir.


*/


CREATE DATABASE PostCode

USE PostCode

SELECT * FROM PostCodes 
ORDER BY Postcode, ValidFrom



























