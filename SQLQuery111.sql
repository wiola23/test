/*
Celem jest przygotowanie procedury składowanej parametryzowanej
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
– rabatu w wysokości 20% w kolejnych linijkach zamówień dotyczących tego produktu.
*/

create procedure procedura1 @klientid nchar(5) as
begin
declare @id int; 
declare custom cursor local for select Orderid from Orders where customerid=@klientid order by orderdate asc;
open custom
fetch next from custom into @id
while @@FETCH_STATUS=0
begin
	with dawnezam as (select orderid from orders where customerid=@klientid and orderdate<(select orderdate from orders where @id=orderid)),
	zliprod as (select productid, count(productid) as liczba from [Order Details] od join dawnezam d on od.orderid=d.orderid group by productid)
	update [Order Details] set discount=
	case
		when liczba=0 then 0.00
		when liczba between 1 and 2 then 0.05
		when liczba=3 then 0.1
		when liczba>3 then 0.2
		else 0.00
	end
	from( [Order Details] od left join zliprod z on od.productid=z.productid);


	FETCH NEXT FROM custom into @id
end
close custom
deallocate custom
end
