# HDR-Panorama-Interface

Project to run a Python server in flask to process images into a HDR Panorama.

## What is this program for?

This program receives images from a mobile device to stitch the images into HDR panoramas. These images may be used as an environment map in 3d modelling.

This project is the backend portion of an entire project. The frontend is here: https://github.com/Cyonopex/PanoImageUploader

The program runs a server that allows the upload of images through REST API calls, and will automate the process of stitching images into a 16-bit floating point HDR panorama in .exr format. It will then launch Blender to preview the use of the HDR panorama as a environment map to illuminate a basic 3D scene.

## Setup

**Requirements:**
* Python 3.6+
* Flask
* Hugin (2019.2.0)
* Blender (2.8.2)
* Flask-Autoindex (Optional)

After installing Hugin, copy all files from Hugin's /bin directory to the repository's /hugin/bin directory.

Then set your Blender installation directory (C:\Program Files\Blender Foundation\Blender 2.82\ in PATH.

## How to use

Run main.py in your Python intepreter to start the server. 

You have 2 ways to upload images into the system.

### Use Android Application

1. Install the application https://github.com/Cyonopex/PanoImageUploader.
2. Ensure phone is in same local network as server, or minimally, is able to contact the server's IP address
3. In the application settings, set the IP address to the server's IP address
4. Upload images through the file picker

### Upload images through Web Browser

Go to http://localhost:5000/. An upload screen will appear to add your files in.

### Output

Images can be found on at server/output. Alternatively, you may run fileserver.py (Flask-Autoindex is needed) to host a server, so you may view files from any device by going to http://localhost/.

## Implementation Details

### Flask Server

The main part of the program is in main.py. A server is hosted in Flask to listen for POST requests. When images are uploaded, Flask will call stitch.bat

### Stitching

In stitch.bat, Hugin is called in the batch file to automate the process of stitching images. Images are output at server/output.
Then cleanup.bat cleans up the files in the server and moves intermediate images to backup.

### Launch of Blender

In startblender.bat, blender.exe is launched with parameters and a python script to set the environment map. 

### 
