@echo off
echo Cleaning Up

MKDIR backup\%1\etc\ >NUL 2>&1
MOVE /Y temp\%1\* backup\%1\etc\ >NUL 2>&1
 
RMDIR /S /Q temp\%1 >NUL 2>&1