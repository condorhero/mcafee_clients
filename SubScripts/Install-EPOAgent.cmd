@ECHO OFF
COLOR 1f

REM	-------------------------------------------------------------------------------
REM	+CHANGE LOG
REM	11/23/2011: Created
REM 12/06/2011: Added Logging, Removed the MCTEMP variable and create dir
REM				Added install check at start
REM	-------------------------------------------------------------------------------	

REM	-------------------------------------------------------------------------------
REM		AUTHOR: Levon Becker 
REM		TITLE: Install-EPOAgent 
REM		PURPOSE: Install Latest McAfee EPO Agent
REM		VERSION: 1.1
REM	-------------------------------------------------------------------------------


CLS
ECHO.	>> %MCAFEELOG%
ECHO	[ATTEMPTING EPO AGENT %CUREPOVER% INSTALL] (%DATE% %TIME%) >> %MCAFEELOG%
CALL %CHECKVERSIONS%
REM CHECK IF EPO INSTALLED
IF "%EPOVER%"=="Not Installed" GOTO EPOINSTALL
ECHO.
ECHO	[EPO AGENT ALREADY INSTALLED]
ECHO.
ECHO.	>> %MCAFEELOG%
ECHO	[EPO AGENT ALREADY INSTALLED] >> %MCAFEELOG%
CALL %SUBSCRIPTS%\WAIT.cmd 2
GOTO END

:EPOINSTALL
CLS
ECHO.
ECHO	[COPYING EPO INSTALL FILE LOCAL]
ECHO.

REM CREATE TEMP FOLDER
SET EPOTEMP=%McAfeeClientsTemp%\EPO
SET EPOVERTEMP=%EPOTEMP%\%CUREPOVER%
IF NOT EXIST "%EPOTEMP%" MKDIR "%EPOTEMP%" > NUL: 2>&1
IF NOT EXIST "%EPOVERTEMP%" MKDIR "%EPOVERTEMP%" > NUL: 2>&1

REM REM WRITE LOG BEFORE SUMMARY
ECHO.	>> %MCAFEELOG%
ECHO	BEFORE EPO INSTALL >> %MCAFEELOG%
CALL "%SUBSCRIPTS%\WriteLog-EPOSUM.cmd" %MCAFEELOG%

REM COPY FILES LOCAL
REM IF NOT EXIST "%McAfeeClientsTemp%\WAIT.cmd" COPY /Y "%DEPSRC%\WAIT.cmd" "%McAfeeClientsTemp%" > NUL: 2>&1
COPY /Y "%EPOINST%\FramePkg.exe" "%EPOVERTEMP%\"

REM Wait 2 seconds
CALL "%SUBSCRIPTS%\WAIT.cmd" 2

CLS
ECHO.
ECHO	[INSTALLING EPO AGENT %CUREPOVER%]
ECHO.
REM Install McAfee Agent 
ECHO	Please Wait...
"%EPOVERTEMP%\FramePkg.exe" /Install=Agent /Silent

REM Wait 5 seconds
CALL "%SUBSCRIPTS%\WAIT.cmd" 5

REM CHECK SUCCESS
CALL %CHECKVERSIONS%
IF "%EPOVER%"=="%CUREPOVER%" GOTO COMPLETED
GOTO ERROR
REM IF NOT EXIST "%EPOPATH%\FrameworkService.exe" GOTO ERROR

:COMPLETED
REM CLEANUP
IF EXIST "%EPOVERTEMP%\FramePkg.exe" DEL /Q "%EPOVERTEMP%\FramePkg.exe"

REM WRITE LOG AFTER SUMMARY
ECHO.	>> %MCAFEELOG%
ECHO	AFTER EPO INSTALL >> %MCAFEELOG%
CALL "%SUBSCRIPTS%\WriteLog-EPOSUM.cmd" %MCAFEELOG%

ECHO.	>> %MCAFEELOG%
ECHO	[EPO AGENT %CUREPOVER% INSTALLED SUCCESSFULLY] (%DATE% %TIME%) >> %MCAFEELOG%

CLS
ECHO.
ECHO	[EPO AGENT %CUREPOVER% INSTALLED SUCCESSFULLY]
ECHO.
ECHO.
SET ERROR=0
REM Wait 2 seconds
CALL %SUBSCRIPTS%\WAIT.cmd 2
GOTO END

:ERROR
COLOR 1c
CLS
ECHO.
ECHO	ERROR: [EPO AGENT INSTALL FAILED]
ECHO.
SET ERROR=1
REM WRITE LOG FAILED SUMMARY
ECHO.	>> %MCAFEELOG%
ECHO	ERROR: [EPO AGENT INSTALL FAILED] (%DATE% %TIME%) >> %MCAFEELOG%
PAUSE
GOTO END

:END