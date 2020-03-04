import os
#import magic
import urllib.request
from app import app
from flask import Flask, flash, request, redirect, render_template, jsonify
from werkzeug.utils import secure_filename
from threading import Thread
import stitchHandler
from os import listdir
from os.path import isfile, join

import logging
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
	
@app.route('/')
def upload_form():
	return render_template('upload.html')

@app.route('/', methods=['POST'])
def upload_file():
	print("POST Request sent to server")
	if request.method == 'POST':
        # check if the post request has the files part
		if 'files[]' not in request.files:
			flash('No file part')
			return redirect(request.url)
		files = request.files.getlist('files[]')
		for file in files:
			if file and allowed_file(file.filename):
				filename = secure_filename(file.filename)
				file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
		flash('File(s) successfully uploaded')
		thread = Thread(target=stitchHandler.stitch)
		thread.start()
		return redirect('/')
		
@app.route('/upload', methods=['POST'])
def upload_file_API():
	# check if the post request has the file part
	if 'files[]' not in request.files:
		resp = jsonify({'message' : 'No file part in the request'})
		resp.status_code = 400
		return resp
	
	files = request.files.getlist('files[]')

	fileName = request.form["fileName"]
	
	errors = {}
	success = False
	
	for file in files:		
		if file and allowed_file(file.filename):
			filename = secure_filename(file.filename)
			filenameNoExt, fileExt = os.path.splitext(filename)
			file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
			success = True
		else:
			errors[file.filename] = 'File type is not allowed'
	
	if success and errors:
		errors['message'] = 'File(s) successfully uploaded'
		resp = jsonify(errors)
		resp.status_code = 500
		return resp
	if success:
		resp = jsonify({'message' : 'Files successfully uploaded'})
		resp.status_code = 201
		thread = Thread(target=stitchHandler.stitch, args=(fileName,))
		thread.start()
		return resp
	else:
		resp = jsonify(errors)
		resp.status_code = 500
		return resp

@app.route('/test', methods=['GET'])
def get_api():
	resp = jsonify({'message':'HELLO WORLD'})
	resp.status_code = 200
	return resp

@app.route('/allimages', methods=['GET'])
def get_all_images():

	fileList = getAllImagesResponse()
	resp = jsonify(fileList)
	resp.status_code = 200
	return resp

def getAllImagesResponse():

	file_list = [{"filename":f} for f in listdir(app.config['IMAGE_LOCATION']) if isfile(join(app.config['IMAGE_LOCATION'], f))]
	file_list_obj = {"data":file_list}

	return file_list_obj

if __name__ == "__main__":
    print("Starting server...")
    app.run(host='0.0.0.0')