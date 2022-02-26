from pydoc import cli
import pymongo
from flask_pymongo import PyMongo
import flask
from flask import jsonify
import json

# Database details
dbname = "test"
host = "localhost"
port = 27017
user_name = "admin"
pass_word = "admin"  

## Initiate API server with flask
app = flask.Flask(__name__)
app.config["DEBUG"] = True

## Initiate mongodb client
app.config["MONGO_URI"] = "mongodb://{host}:27017/{dbname}"
mongodb_client = PyMongo(app)
db = mongodb_client.db

# mydb = mongodb_client["mydatabase"]

# # Create a collection
# mycol = mydb["customers"]

# List of dictionaries
# mydict =  { "username": "John", "userid": "Highway37" ,"price": "20", "timestamp": "20-2-2022" }

# Create some purchases data
purchases_details = [
    {'userid': 0,
     'username': 'yahav',
     'price': '100',
     'timestamp': '25-2-2022',},
    {'userid': 1,
     'username': 'shlomi',
     'price': '200',
     'timestamp': '25-2-2023',},
    {'userid': 2,
     'username': 'khen',
     'price': '300',
     'timestamp': '25-2-2024',}
]
  
@app.route("/purchases")
def purchases():
    db.todos.insert_one({'_id': 1, 'title': "todo title one ", 'body': "todo body one "})
    return flask.jsonify(message="success")

    # db.todos.insert_many(purchases_details)

# Create route /purchases to get list of purchases.
@app.route('/', methods=['GET'])
def home():
    return "<h1>Distant Reading Archive</h1><p>This site is a prototype API for distant reading of science fiction novels.</p>"

# @app.route('/buy', methods=['GET'])
# def test():
#     return jsonify(purchases_details)

app.run()