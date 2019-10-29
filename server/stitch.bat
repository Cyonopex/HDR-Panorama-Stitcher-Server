SET filename=%1

echo Generate .PTO project file
..\hugin\bin\pto_gen -o temp\p.pto images\*.jpg

echo Generate and prune control points
..\hugin\bin\cpfind -o temp\p.pto --multirow --celeste temp\p.pto
..\hugin\bin\celeste_standalone -i temp\p.pto -o temp\p.pto
..\hugin\bin\cpclean -o temp\p.pto temp\p.pto

echo Use Hugin's Autooptimiser
..\hugin\bin\autooptimiser -a -l -s -m -o temp\p.pto temp\p.pto

echo Set output options
..\hugin\bin\pano_modify -o temp\p.pto --center --straighten --canvas=AUTO --crop=AUTO --output-type=HDR --hdr-file=EXR --hdr-compression=LZW  temp\p.pto

echo Generate remapped photos
..\hugin\bin\nona -m EXR_m -r hdr -o temp\p temp\p.pto

..\hugin\bin\enblend -o output\%filename%.exr temp\p*.exr