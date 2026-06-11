from db import get_connection
import queries
import random

def print_table(cursor, stage_name):
    """Funkcja pomocnicza wyświetlająca stan tabeli."""
    print(f"\n--- STAN TABELI PO: {stage_name} ---")
    rows = queries.get_all_faktury(cursor)
    if not rows:
        print("Tabela jest pusta.")
    for r in rows:
        print(f"ID: {r[0]} | Netto: {r[1]} | Brutto: {r[2]} | Konto: {r[3]}")
    print("-" * 50)


def main():
    connection = None
    try:
        connection = get_connection()
        next_id = 1  # Zmienna do ręcznego sterowania kluczem głównym

        with connection.cursor() as cursor:

            queries.delete_all_faktury(cursor)
            connection.commit()
            print_table(cursor, "Transakcja 1 (Usunięcie wszystkich rekordów)")


            kwoty_netto = [100.0, 200.0, 300.0]
            for netto in kwoty_netto:
                brutto = round(netto * 1.23, 2)
                queries.insert_faktura(cursor, next_id, netto, brutto, f"KONTO_POCZATKOWE_{next_id}")
                next_id += 1
            connection.commit()
            print_table(cursor, "Transakcja 2 (Utworzenie 3 rekordów)")


            queries.double_brutto(cursor)

            netto_dla_1000 = round(1000.0 / 1.23, 2)
            queries.insert_faktura(cursor, next_id, netto_dla_1000, 1000.0, "KONTO_SPECJALNE")
            next_id += 1
            connection.commit()
            print_table(cursor, "Transakcja 3 (Podwojenie brutto i faktura na 1000 PLN)")

            inserted_ids_in_loop = []
            
            for _ in range(10):
                netto = round(random.uniform(50, 500), 2)
                brutto = round(netto * 1.23, 2)
                queries.insert_faktura(cursor, next_id, netto, brutto, f"KONTO_LOSOWE_{next_id}")
                inserted_ids_in_loop.append(next_id)
                next_id += 1
            
            ids_to_modify = random.sample(inserted_ids_in_loop, 3)
            for mod_id in ids_to_modify:
                nowe_netto = round(random.uniform(2000, 5000), 2)
                nowe_brutto = round(nowe_netto * 1.23, 2)
                queries.update_faktura_random(cursor, mod_id, nowe_netto, nowe_brutto)
                
            connection.commit()
            print_table(cursor, "Transakcja 4 (10 nowych i modyfikacja 3 losowych)")

    except Exception as e:
        if connection:
            connection.rollback()
            print("Wystąpił błąd, cofnięto zmiany (ROLLBACK).")
        print("Błąd:", e)

    finally:
        if connection:
            connection.close()

if __name__ == "__main__":
    main()

"""2.	Przygotować projekt o nazwie ZAD2_[NAZWISKO_INDEKS] w PyCharm lub Visual Studio, a w nim jedną klasę, która zawiera kolejne transakcje:
a.	W transakcji pierwszej usuwa istniejące rekordy z w/w tabeli 
b.	W transakcji drugiej tworzy trzy rekordy w w/w tabeli o kwotach netto 100, 200 i 300 i brutto równych 1.23*netto (wartości netto i brutto mogą być na sztywno zakodowane w kodzie aplikacji)
c.	W transakcji trzeciej wykonuje dwie operacje:
i.	modyfikuje rekordy poprzez zmianę kwoty brutto polegającą na jej dwukrotnym zwiększeniu
ii.	dopisuje fakturę o kwocie brutto 1000 PLN
d.	w czwartej transakcji:
i.	 w pętli tworzy 10 rekordów o kolejnych wartościach w kolumnie klucza głównego i losowych wartościach w pozostałych kolumnach, 
ii.	a następnie trzy losowo wybrane rekordy poddaje zmianom (również losowym) 
3.	Uwagi:
a.	Klasę należy wykorzystać do stworzenia aplikacji konsolowej, która powinna mieć postać tzw. grubego klienta, który zestawia połączenie do bazy danych bez wykorzystania puli połączeń i z chwilą uruchomienia wykonuje w/w operacje
b.	Po każdej z transakcji należy pobrać z bazy danych zawartość całej tabeli i wyświetlić je w postaci komunikatów w oknie konsoli (np. z użyciem print())
c.	Aplikacja nie musi pobierać danych do wpisania do bazy danych z interfejsu użytkownika.
 """