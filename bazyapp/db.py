import pymssql
import configparser

def get_connection():
    config = configparser.ConfigParser()
    config.read("cnf.ini")

    db = config["mssqlDB"]

    return pymssql.connect(
        server=db["server"],
        user=db["user"],
        password=db["pass"],
        database=db["db"],
        autocommit=False
    )