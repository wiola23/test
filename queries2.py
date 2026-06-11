def get_next_id(cursor):
    """Pomocnicza funkcja do pobierania bezpiecznego USER_ID"""
    cursor.execute("SELECT ISNULL(MAX([USER_ID]), 0) + 1 FROM participants")
    return cursor.fetchone()[0]

def get_all_participants(cursor):
    cursor.execute("SELECT * FROM participants")
    return cursor.fetchall()

def delete_oldest_inactive(cursor):
    cursor.execute("""
        DELETE FROM participants
        WHERE is_active = 0 
        AND JOIN_DATE = (SELECT MIN(JOIN_DATE) FROM participants WHERE is_active = 0)
    """)

def insert_participant(cursor, uid, email, is_active, join_date, amount, points, points_per_comp=None):
    if points_per_comp is None:
        cursor.execute("""
            INSERT INTO participants (
                [USER_ID], email, is_active, JOIN_DATE, 
                TOTAL_AMOUNT_OF_COMPETITIONS, TOTAL_POINTS
            ) VALUES (%s, %s, %s, %s, %s, %s)
        """, (uid, email, is_active, join_date, amount, points))
    else:
        cursor.execute("""
            INSERT INTO participants (
                [USER_ID], email, is_active, JOIN_DATE, 
                TOTAL_AMOUNT_OF_COMPETITIONS, TOTAL_POINTS, POINTS_PER_COMPETITION
            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (uid, email, is_active, join_date, amount, points, points_per_comp))

def add_points_to_all(cursor, points_to_add):
    cursor.execute("UPDATE participants SET TOTAL_POINTS = TOTAL_POINTS + %s", (points_to_add,))

def get_min_max_inactive_dates(cursor):
    cursor.execute("SELECT MIN(JOIN_DATE), MAX(JOIN_DATE) FROM participants WHERE is_active = 0")
    return cursor.fetchone()

def get_inactive_users_by_date(cursor, target_date):
    cursor.execute("SELECT [USER_ID] FROM participants WHERE is_active = 0 AND JOIN_DATE = %s", (target_date,))
    return [row[0] for row in cursor.fetchall()]

def update_join_date(cursor, user_id, new_date):
    cursor.execute("UPDATE participants SET JOIN_DATE = %s WHERE [USER_ID] = %s", (new_date, user_id))


"""READ UNCOMMITTED: Najniższy poziom, zezwala na wszystkie anomalie, w tym brudne odczyty.  

READ COMMITTED: Domyślny poziom w wielu systemach, chroni przed brudnymi odczytami.  

REPEATABLE READ: Chroni dodatkowo przed niepowtarzalnymi odczytami.  

SERIALIZABLE / SNAPSHOT: Najwyższe poziomy izolacji chroniące również przed fantomami (odpowiadają szeregowemu wykonywaniu transakcji)."""