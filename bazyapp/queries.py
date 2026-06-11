def get_all_faktury(cursor):
    cursor.execute("SELECT Id_faktury, Kwota_netto, Kwota_brutto, Nr_konta FROM FAKTURY_Kowalski_12345")
    return cursor.fetchall()

def delete_all_faktury(cursor):
    cursor.execute("DELETE FROM FAKTURY_Kowalski_12345")

def insert_faktura(cursor, id_faktury, netto, brutto, nr_konta):
    cursor.execute(
        "INSERT INTO FAKTURY_Kowalski_12345 (Id_faktury, Kwota_netto, Kwota_brutto, Nr_konta) VALUES (%s, %s, %s, %s)",
        (id_faktury, netto, brutto, nr_konta)
    )

def double_brutto(cursor):
    cursor.execute("UPDATE FAKTURY_Kowalski_12345 SET Kwota_brutto = Kwota_brutto * 2")

def update_faktura_random(cursor, id_faktury, new_netto, new_brutto):
    cursor.execute(
        "UPDATE FAKTURY_Kowalski_12345 SET Kwota_netto = %s, Kwota_brutto = %s WHERE Id_faktury = %s",
        (new_netto, new_brutto, id_faktury)
    )