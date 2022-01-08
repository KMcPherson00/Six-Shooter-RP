@echo off
rem START or STOP Services
rem ----------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop

if exist D:\GitHub\Six-Shooter-RP\Xampp\hypersonic\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\server\hsql-sample-database\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\ingres\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\ingres\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\mysql\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\mysql\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\postgresql\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\postgresql\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\apache\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\apache\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\openoffice\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\openoffice\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\apache-tomcat\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\apache-tomcat\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\resin\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\resin\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\jetty\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\jetty\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\subversion\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\subversion\scripts\ctl.bat START)
rem RUBY_APPLICATION_START
if exist D:\GitHub\Six-Shooter-RP\Xampp\lucene\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\lucene\scripts\ctl.bat START)
if exist D:\GitHub\Six-Shooter-RP\Xampp\third_application\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\third_application\scripts\ctl.bat START)
goto end

:stop
echo "Stopping services ..."
if exist D:\GitHub\Six-Shooter-RP\Xampp\third_application\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\third_application\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\lucene\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\lucene\scripts\ctl.bat STOP)
rem RUBY_APPLICATION_STOP
if exist D:\GitHub\Six-Shooter-RP\Xampp\subversion\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\subversion\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\jetty\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\jetty\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\hypersonic\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\server\hsql-sample-database\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\resin\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\resin\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\apache-tomcat\scripts\ctl.bat (start /MIN /B /WAIT D:\GitHub\Six-Shooter-RP\Xampp\apache-tomcat\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\openoffice\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\openoffice\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\apache\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\apache\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\ingres\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\ingres\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\mysql\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\mysql\scripts\ctl.bat STOP)
if exist D:\GitHub\Six-Shooter-RP\Xampp\postgresql\scripts\ctl.bat (start /MIN /B D:\GitHub\Six-Shooter-RP\Xampp\postgresql\scripts\ctl.bat STOP)

:end

