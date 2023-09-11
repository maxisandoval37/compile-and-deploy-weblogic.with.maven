@echo off
setlocal enabledelayedexpansion
color 0A
title compile-and-deploy-maven-weblogic
mode con: cols=120 lines=35

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

REM Menu weblogic clusters
echo Select one of the weblogic clusters:

echo.
echo 1. Cluster-1
echo 2. Cluster-2
echo 3. Cluster-3
echo 4. Cluster-4
echo 5. Cluster-5
echo 6. Cluster-6
echo 7. Cluster-7
echo 8. Cluster-8
echo 9. EXIT
echo.

choice /c 123456789 /n /m "Select option (1-9)"
set targetChoice=%errorlevel%

REM Verify user selection
if "%targetChoice%"=="1" (
   set "targets=Cluster-1"
) else if "%targetChoice%"=="2" (
   set "targets=Cluster-2"
) else if "%targetChoice%"=="3" (
   set "targets=Cluster-3"
) else if "%targetChoice%"=="4" (
   set "targets=Cluster-4"
) else if "%targetChoice%"=="5" (
   set "targets=Cluster-5"
) else if "%targetChoice%"=="6" (
   set "targets=Cluster-6"
) else if "%targetChoice%"=="7" (
   set "targets=Cluster-7"
) else if "%targetChoice%"=="8" (
   set "targets=Cluster-8"
) else if "%targetChoice%"=="9" (
   color 04
   echo.
   echo "*****************************************"
   echo "***********UNTIL NEXT TIME >:)***********"
   echo "*****************************************"
   timeout /t 3
   @cls&exit
)

REM Execute mvn clean install
call mvn clean install
echo.

REM Get current folder name
for %%A in (.) do set "lastFolder=%%~nxA"

REM ********************TODO COMPLETE! Path and variables********************
set "weblogicHome=C:\Oracle\Middleware\wlserver_10.3"
set "domainHome=C:\Oracle\Middleware\user_projects\domains\base_domain"
set "WLjarpath=C:\Oracle\Middleware\wlserver_10.3\server\lib\weblogic.jar"
set "serverIpPort=YOUR_IP:7001"
set "user=YOUR_USER"
set "pass=YOUR_PASS"
set "appName=!lastFolder!"
REM *************************************************************************

REM Find generated .war file
set "origin="
for /r "." %%f in (*.war) do (
    set "origin=%%f"
    
    for %%g in ("!origin!") do set "warName=%%~nxg"
    echo WAR located: !warName!
    echo.
)

REM App Undeploy
REM TRY 1:
call java -cp java -cp !WLjarpath! weblogic.Deployer -verbose -noexit -adminurl !serverIpPort! -username !user! -password !pass! -name !appName! -undeploy -timeout 300 -usenonexclusivelock

REM TRY 2:
timeout /t 1
echo.
call java -cp java -cp !WLjarpath! weblogic.Deployer -verbose -noexit -adminurl !serverIpPort! -username !user! -password !pass! -name !warName! -undeploy -timeout 300 -usenonexclusivelock

REM Wait...
timeout /t 3
echo.

REM App Deploy
call java -cp !WLjarpath! weblogic.Deployer -verbose -noexit -adminurl !serverIpPort! -username !user! -password !pass! -source target/!warName! -targets !targets! -stage -upload -deploy -timeout 300

echo.
echo The app !appName! has been deployed to !targets!.

echo.
echo                    SCRIPT RUN SUCCESSFULL
echo.
echo ##########################################################
echo ###########CREDITS BY GITHUB.COM/MAXISANDOVAL37###########
echo ##########################################################
echo.

PAUSE
