# HDR-Panorama-Interface

Project to run a Python server in flask to process images into a HDR Panorama.

## What is this program for?

This program receives images from a mobile device to stitch the images into HDR panoramas. These images may be used as an environment map in 3d modelling.

This project is the backend portion of an entire project. The frontend is here: https://github.com/Cyonopex/PanoImageUploader

## Setup

**Requirements:**
* Python 3.6+
* Flask
* Hugin (2019.2.0)
* Blender (2.8.2)

Step 1: Install [Python 3.6+](https://www.python.org/) and Flask Library 

`pip install flask`

Step 1: Install [Hugin](http://hugin.sourceforge.net/), and [Blender](https://www.blender.org/)

Step 2: Clone this repository to your computer at any location

Step 3: Copy all files from Hugin's /bin directory (C:\Program Files\Hugin\Bin) to your repository's /hugin/bin directory.

Step 4: Add the Blender installation directory (typically C:\Program Files\Blender Foundation\Blender 2.82\) into PATH.

## How to use

Run main.py in your Python intepreter to start the server. 

`python main.py` or `python3 main.py`

You have 2 ways to upload images into the system.

### Use Android Application

1. Install the application from https://github.com/Cyonopex/PanoImageUploader.
2. Ensure phone is in same local network as server, or minimally, is able to contact the server's IP address
3. In the application settings, set the IP address to the computer's IP address (use ipconfig on the computer to get the local IP address)
4. Upload images through the file picker by pressing the upload button on the bottom right.

### Upload images through Web Browser

Go to http://localhost:5000/. An upload screen will appear to add your files in.

### Blender Preview

The server will automatically launch Blender to preview the image as an environmental map of the scene. You may click and drag around the axes to preview the environment.

### Output

Images can be found on at server/output. These .EXR images may be imported to any program.

Alternatively, you may run fileserver.py (Flask-Autoindex is needed) to host a server, so you may view files from any device by going to http://localhost/.

## Implementation Details

The program runs a server that allows the upload of images through REST API calls, and will automate the process of stitching images into a 16-bit floating point HDR panorama in .exr format. It will then launch Blender to preview the use of the HDR panorama as a environment map to illuminate a basic 3D scene.

### Flask Server

The main part of the program is in main.py. A server is hosted in Flask to listen for POST requests. When images are uploaded, Flask will call stitch.bat

### Stitching

In stitch.bat, Hugin is called in the batch file to automate the process of stitching images. Images are output at server/output.
Then cleanup.bat cleans up the files in the server and moves intermediate images to backup.

### Launch of Blender

In startblender.bat, blender.exe is launched with parameters and a python script to set the environment map. 
