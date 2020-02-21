from flask import Flask

UPLOAD_FOLDER = 'images'

app = Flask(__name__)
app.secret_key = "secret key"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 256 * 1024 * 1024
app.config['IMAGE_LOCATION'] = './images'