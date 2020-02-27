@echo off

echo STARTING BLENDER...

copy sphere.blend /y blender\sphere.blend >NUL
blender blender\sphere.blend --python blender\makeenvmap.py