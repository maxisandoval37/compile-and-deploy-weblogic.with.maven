@echo off
setlocal enabledelayedexpansion
color 0A
title compile-and-deploy-maven-weblogic

echo ##########################################################
echo ###########CREDITS BY GITHUB.COM/MAXISANDOVAL37###########
echo ##########################################################
echo.
echo                  _________-----_____
echo        ____------           __      ----_
echo  ___----             ___------              \
echo     ----________        ----                 \
echo                -----__    ^|             _____)
echo                     __-                /     \
echo         _______-----    ___--          \    /)\
echo   ------_______      ---____            \__/  /
echo                -----__    \ --    _          /\
echo                       --__--__     \_____/   \_/\
echo                               ---^|   /          ^|
echo                                  ^| ^|___________^|
echo                                  ^| ^| ((_(_)^| )_)
echo                                  ^|  \_((_(_)^|/(_)
echo                                   \             (
echo                                    \_____________)
echo.
echo.

REM Execute mvn clean install
call mvn clean install
echo.

REM Get current folder name
for %%A in (.) do set "lastFolder=%%~nxA"

REM ********************TODO COMPLETE! Path and variables********************
set "weblogicHome=C:\Oracle\Middleware\wlserver_10.3"
set "domainHome=C:\Oracle\Middleware\user_projects\domains\base_domain"
set "WLjarpath=C:\Oracle\Middleware\wlserver_10.3\server\lib\weblogic.jar"
set "serverIpPort=localhost:7001"
set "user=weblogic"
set "pass=admin123"
set "appName=!lastFolder!"
REM *************************************************************************

REM Find generated .war file
set "origen="
for /r "." %%f in (*.war) do (
    set "origen=%%f"
    
    for %%g in ("!origen!") do set "warName=%%~nxg"
    echo WAR located: !warName!
    echo.
)

REM App Undeploy
REM TRY 1:
call java -cp java -cp !WLjarpath! weblogic.Deployer -verbose -noexit -adminurl !serverIpPort! -username !user! -password !pass! -name !appName! -undeploy -timeout 300 -usenonexclusivelock
REM TRY 2:
timeout /t 1
call java -cp java -cp !WLjarpath! weblogic.Deployer -verbose -noexit -adminurl !serverIpPort! -username !user! -password !pass! -name !warName! -undeploy -timeout 300 -usenonexclusivelock

REM Wait...
timeout /t 3

REM App Deploy
call java -cp !WLjarpath! weblogic.Deployer -verbose -noexit -adminurl !serverIpPort! -username !user! -password !pass! -source target/!warName! -upload -deploy -timeout 300

echo.
echo The app !appName! has been deployed in WebLogic.

echo.
echo                    SCRIPT RUN SUCCESSFULL
echo.
echo ##########################################################
echo ###########CREDITS BY GITHUB.COM/MAXISANDOVAL37###########
echo ##########################################################
echo.

PAUSE
