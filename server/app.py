from flask import Flask

app = Flask(__name__)
app.secret_key = "secret key"
app.config['UPLOAD_FOLDER'] = 'images'
app.config['MAX_CONTENT_LENGTH'] = 256 * 1024 * 1024
app.config['IMAGE_LOCATION'] = './output'