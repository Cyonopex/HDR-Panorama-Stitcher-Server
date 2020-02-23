SET filename=%1

mkdir backup\%1
mkdir temp\%1
del /S /Q backup\%1
del output\%filename%.exr
MOVE /Y images\* backup\%1

echo Generate .PTO project file
..\hugin\bin\pto_gen -o temp\%1\p.pto backup\%1\*.*

echo Clear images folder for next batch

echo Generate and prune control points
..\hugin\bin\cpfind -o temp\%1\p.pto --multirow --celeste temp\%1\p.pto
..\hugin\bin\celeste_standalone -i temp\%1\p.pto -o temp\%1\p.pto
..\hugin\bin\cpclean -o temp\%1\p.pto temp\%1\p.pto

echo Use Hugin's Autooptimiser
..\hugin\bin\autooptimiser -a -l -s -o temp\%1\p.pto temp\%1\p.pto

echo Custom vig_optimize (for HDR, fixed exposure)

..\hugin\bin\pto_var --opt Vb,Vx,Ra -o temp\%1\p.pto temp\%1\p.pto

..\hugin\bin\vig_optimize -o temp\%1\p.pto temp\%1\p.pto

echo Set output options
..\hugin\bin\pano_modify -o temp\%1\p.pto --center --straighten --canvas=AUTO --crop=AUTO --output-type=HDR --hdr-file=EXR --hdr-compression=LZW  temp\%1\p.pto

echo Generate remapped photos
..\hugin\bin\nona -m EXR_m -r hdr -o temp\%1\p temp\%1\p.pto

..\hugin\bin\enblend -o output\%filename%.exr temp\%1\p*.exr
