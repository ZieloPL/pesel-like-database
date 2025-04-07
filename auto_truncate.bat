@ECHO OFF

SET SQLCMD="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\SQLCMD.EXE"

SET PATH ="C:\Users\janzi\OneDrive\Pulpit\Bazowanie_danych\Zadanie_dodatkowe_Jan_Zielinski\truncate.sql"

SET SERVER="LAPTOP-LJD5UIED"

SET LOGIN="sa"

SET PASSWORD="pass"

SET DB="PESEL"

SET INPUT="truncate.sql"

SET OUTPUT="output.txt"

%SQLCMD% -S %SERVER% -d %DB% -E -i %INPUT% -o %OUTPUT%