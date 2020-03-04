@echo off
SET filename=%1 >nul 2>&1

mkdir backup\%1 >nul 2>&1
mkdir temp\%1 >nul  2>&1
del /S /Q backup\%1 >nul 2>&1
del output\%filename%.exr >nul 2>&1
MOVE /Y images\* backup\%1 >nul 2>&1

echo Step 1/7: Generate .PTO project file
..\hugin\bin\pto_gen -o temp\%1\p.pto backup\%1\*.* >nul

echo Step 2/7: Clear images folder for next batch

echo Step 3/7: Generate and prune control points
..\hugin\bin\cpfind -o temp\%1\p.pto --multirow --celeste temp\%1\p.pto >nul
..\hugin\bin\celeste_standalone -i temp\%1\p.pto -o temp\%1\p.pto >nul
..\hugin\bin\cpclean -o temp\%1\p.pto temp\%1\p.pto >nul

echo Step 4/7: Use Hugin's Autooptimiser
..\hugin\bin\autooptimiser -a -l -s -o temp\%1\p.pto temp\%1\p.pto >nul

echo Step 5/7: Custom vig_optimize (for HDR, fixed exposure)

..\hugin\bin\pto_var --opt Vb,Vx,Ra -o temp\%1\p.pto temp\%1\p.pto >nul

..\hugin\bin\vig_optimize -o temp\%1\p.pto temp\%1\p.pto >nul

echo Step 6/7: Set output options
..\hugin\bin\pano_modify -o temp\%1\p.pto --center --straighten --canvas=AUTO --crop=AUTO --output-type=HDR --hdr-file=EXR --hdr-compression=LZW  temp\%1\p.pto >nul

echo Step 7/7: Generate remapped photos
..\hugin\bin\nona -m EXR_m -r hdr -o temp\%1\p temp\%1\p.pto >nul 2>&1

..\hugin\bin\enblend -o output\%1.exr temp\%1\p*.exr >nul 2>&1

copy /Y output\%1.exr blender\image.exr >nul 2>&1

echo STITCHING COMPLETE