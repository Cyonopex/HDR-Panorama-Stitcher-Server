mkdir backup\%1
mkdir backup\%1\temp

MOVE /Y images\* backup\%1
MOVE /Y temp\* backup\%1\temp