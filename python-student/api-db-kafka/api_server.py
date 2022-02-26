import flask

app = flask.Flask(__name__)
app.config["DEBUG"] = True


@app.route('/purchases', methods=['GET'])
def home():
    return "<h1>Distant Reading Archive</h1><p>This site is a prototype API for distant reading of science fiction novels.</p>"

@app.route('/buy', methods=['GET'])
def test():
    return "<h1>test API response.</p>"

app.run()