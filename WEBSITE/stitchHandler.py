import os

def stitch():

    files = os.listdir(os.path.join(os.path.dirname(__file__), 'images'))
    if not files:
        return False
    filename = files[0]
    filename, fileExt = os.path.splitext(filename)
    command = "stitch.bat " + filename

    output = os.system(command)

    command2 = "cleanup.bat " + filename
    output2 = os.system(command2)