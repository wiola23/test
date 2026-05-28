/*Celem jest przygotowanie procedury składowanej parametryzowanej
identyfikatorem klienta (CustomerId)
• Procedura dla każdego zamówienia tego klienta sprawdza liczbę
zamówień złożonych wcześniej przez klienta na dany produkt:
– Jeśli wynosi ona od 1 do 2, udzielana jest zniżka w wysokości 5%,
– Jeśli wynosi ona 3, przysługuje zniżka 10%,
– Jeśli liczba ta jest powyżej 3, przysługuje zniżka 20%,
– Jeśli zamówienie jest pierwszym zamówieniem dla tego produktu, zniżka to 0%.
– Wartość rabatu w procentach jest zapisywana przez procedurę w kolumnie discount w
tabeli [Order details]
• Zniżka jest zawsze ustawiana tylko w zamówieniu aktualnie
przetwarzanym. W przypadku, gdy klient złożył 5 zamówień na dany
produkt, zamiarem jest ustawienie:
– rabatu w wysokości 0% w pierwszym zamówieniu na ten produkt,
– rabatu 5% w drugim i trzecim zamówieniu na ten produkt,
– rabatu 10% w czwartym zamówieniu na ten produkt,
– rabatu w wysokości 20% w kolejnych linijkach zamówień dotyczących tego produktu.*/
CREATE PROCEDURE procedura2 @klientid nchar(5) AS
BEGIN
with zliczanie as (SELECT od.*,  count(productid) over(partition by productid order by orderdate,o.orderid rows between unbounded preceding and 1 preceding) as liczba
FROM [Order Details] od join orders o on o.orderid=od.orderid where o.customerid=@klientid)
update [Order Details] set discount=
case 
	when liczba=0 then 0.00
	when liczba between 1 and 2 then 0.05
	when liczba=3 then 0.1
	when liczba>3 then 0.2
	else 0.0
end
from zliczanie z join [Order Details] od on od.orderid=z.OrderID and od.productid=z.productid; 
END


select * from  [Order Details] od join orders o on o.orderid=od.orderid where o.customerid='ALFKI' order by OrderDate;
exec procedura2 'ALFKI';
select * from  [Order Details] od join orders o on o.orderid=od.orderid where o.customerid='ALFKI' order by OrderDate;
