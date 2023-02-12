from flask import Flask, jsonify, request
import os 
from dotenv import load_dotenv
from flaskext.mysql import MySQL
from pymysql.cursors import DictCursor
from datetime import datetime, timedelta

load_dotenv(dotenv_path='.env')

app = Flask(__name__)

app.config['MYSQL_DATABASE_USER'] = os.environ['USERNAME']
app.config['MYSQL_DATABASE_PASSWORD'] = os.environ['PASSWORD']
app.config['MYSQL_DATABASE_DB'] = os.environ['DATABASE']
app.config['MYSQL_DATABASE_HOST'] = os.environ['HOST']

mysql = MySQL(app, cursorclass=DictCursor)

conn = mysql.connect()

@app.route("/select", methods=['POST', 'GET'])
def select():
    try:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM tasks WHERE completed_by < %s", datetime.now())
        conn.commit()
        data = request.get_json()
        table = data['table']
        try:
            data = data['data']
        except:
            data = dict({})
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        if table in [i['Tables_in_goal_tracker'] for i in tables]:
            cursor.execute("""SELECT COLUMN_NAME FROM information_schema.columns WHERE table_name = %s AND data_type = %s""", ('tasks', 'timestamp'))
            table_columns = cursor.fetchall()
            for column in [i['COLUMN_NAME'] for i in table_columns]:
                try:
                    data[column] = datetime.strptime(data[column], "%d/%m/%Y")
                except Exception as e:
                    pass
            if data:
                columns = [f'{list(data.keys())[i]} IN %s' if (type(list(data.values())[i]) == list) else f'{list(data.keys())[i]} = %s' for i in range(len(data.keys()))]
                columns = ' AND '.join(columns)
                sql = f"""SELECT * FROM {table} WHERE {columns}"""
            else:
                sql = f"""SELECT * FROM {table}"""
            cursor.execute(sql, tuple([tuple(i) if type(i) == list else i for i in data.values()]))
            returndata = cursor.fetchall()
        cursor.close()
    except Exception as e:
        return str(e)
    print(returndata)
    if returndata:
        return jsonify(returndata)
    else:
        return jsonify(returndata)

@app.route("/insert", methods=['POST'])
def insert():
    try:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM tasks WHERE completed_by < %s", datetime.now())
        conn.commit()
        data = request.get_json()
        table = data['table']
        data = data['data']
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        if table in [i['Tables_in_goal_tracker'] for i in tables]:
            cursor.execute("""SELECT COLUMN_NAME FROM information_schema.columns WHERE table_name = %s AND data_type = %s""", ('tasks', 'timestamp'))
            table_columns = cursor.fetchall()
            for column in [i['COLUMN_NAME'] for i in table_columns]:
                try:
                    data[column] = datetime.strptime(data[column], "%d/%m/%Y")
                except Exception as e:
                    pass
            columns = ", ".join(data.keys())
            valuenum = ["%s" for i in range(len(data.keys()))]
            valuenum = ", ".join(valuenum)
            print(table)
            print(columns)
            print(valuenum)
            print(data.values())
            sql = f"""INSERT INTO {table}({columns}) VALUES ({valuenum})"""
            print(sql)
            cursor.execute(sql, tuple(data.values()))
            conn.commit()
        cursor.close()
    except Exception as e:
        print(e)
        return str(e)
    return "Inserted!"

@app.route("/delete", methods=['POST'])
def delete():
    try:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM tasks WHERE completed_by < %s", datetime.now())
        conn.commit()
        data = request.get_json()
        table = data['table']
        data = data['data']
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        if table in [i['Tables_in_goal_tracker'] for i in tables]:
            cursor.execute("""SELECT COLUMN_NAME FROM information_schema.columns WHERE table_name = %s AND data_type = %s""", ('tasks', 'timestamp'))
            table_columns = cursor.fetchall()
            for column in [i['COLUMN_NAME'] for i in table_columns]:
                try:
                    data[column] = datetime.strptime(data[column], "%d/%m/%Y")
                except Exception as e:
                    pass
            columns = [f'{list(data.keys())[i]} IN %s' if (type(list(data.values())[i]) == list) else f'{list(data.keys())[i]} = %s' for i in range(len(data.keys()))]
            columns = ' AND '.join(columns)
            sql = f"""DELETE FROM {table} WHERE {columns}"""
            cursor.execute(sql, tuple([tuple(i) if type(i) == list else i for i in data.values()]))
            conn.commit()
        cursor.close()
    except Exception as e:
        return str(e)
    return "Deleted!"

