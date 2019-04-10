@echo off

::Location of your Liferay Portal
SET portal=L:\private\7.0.x-portal


echo deleting portal-web/tests...
rmdir /s %portal%\portal-web\tests\

echo deleting tools\selenium
rmdir /s %portal%\tools\selenium

echo deleting poshi-warnings.xml
del %portal%\poshi-warnings.xml

echo deleting output.bin
del %portal%\portal-web\test-results\binary\runPoshi\output.bin

del null*