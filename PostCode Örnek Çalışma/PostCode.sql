
/*

PostCodes.csv dosyasý 4 sütundan oluþmaktadýr.

1. Postcode: 4 haneli posta kodu numarasý
2. PostcodeName: Posta kodunun adý (o bölgenin adý)
3. ValidFrom: Hangi tarihten itibaren geçerli olduðu
4. ValidTo: Hangi tarihe kadar geçerli olduðu

Bir posta kodu kapatýlabilir.
Belli bir süre askýya alýnabilir.
Bir posta kodunun adý deðiþebilir.

Ayný gün kapanýp ayný gün yeniden açýlan ve adý deðiþmemiþ posta kodlarý ayný posta kodu olarak kabul edilir.
Hangi gün kapanýp hangi gün açýlýrsa açýlsýn bir posta kodunun adý deðiþmiþse bu durumda eski posta kodu kapanmýþ sayýlýr. 
Yeni isimli posta kodu ise ilk defa açýlmýþ farklý bir posta kodudur.
Ayný tarihte bir posta kodunun iki farklý adý olamaz.
ValidTo sütunu boþ olan kayýtlar postakodunun halen geçerli olduðunu anlamýna gelir.

Eðer bir posta kodunun adý deðiþmemiþse ve askýya alýnma tarihi ile ayný posta kodunun yeniden açýlma tarihleri ayný ise bu satýrlarýn tek bir satýrda toplanmasý gerekmektedir.

Postcode	PostcodeName	ValidFrom	ValidTo
1		A		01.01.1999	01.02.1999
1		A		01.02.1999	

Örneðin yukarýdaki örnekte 1 numaralý Postkodu 1 Ocak 1999 tarihinde açýlmýþ ve 1 Þubat 1999 tarihinde kapatýlmýþ. 
Fakat ayný gün ayný posta numarasý ayný isimle yeniden açýlmýþ ve halen de geçerli bir posta kodu. Dolayýsýyla bu iki satýr birleþtirilecektir ve aþaðýdaki þekilde tutulacaktýr:

Postcode	PostcodeName	ValidFrom	ValidTo
1		A		01.01.1999

Eðer bu örnekte 2. satýrda yer alan posta kodu ayný gün deðil de daha sonra açýlmýþ olsaydý bu durumda ikinci kayýt yeni bir postakodu gibi düþünelecektir. Ve bu iki satýr birleþtirilmeyecektir.

Bir baþka örnek vermek gerekirse Postcode: 1 in adýnýn ilk önce A sonra B olduðunu varsayalým. 
Bu durumda B isimli posta kodunun açýldýðý tarih A isimli posta kodunun kapandýðý tarihe eþit de olsa farklý da olsa bu posta kodu yeni bir posta kodu olup bu tip durumlarda da satýrlar birleþtirilmeyecektir.


*/


CREATE DATABASE PostCode

USE PostCode

SELECT * FROM PostCodes 
ORDER BY Postcode, ValidFrom



























