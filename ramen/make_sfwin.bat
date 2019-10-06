REM params: <buildname> <main.f> <projectpath>
SETLOCAL

pushd "%temp%"
makecab /D RptFileName=~.rpt /D InfFileName=~.inf /f nul >nul
for /f "tokens=3-7" %%a in ('find /i "makecab"^<~.rpt') do (
   set "mydate=%%e-%%b-%%c"
   set "mytime=%%d"
)
del ~.*
popd



if %1=="" (
    SET buildname=build
) else (
    SET buildname=%1
)

SET foldername=%buildname%_%mydate%_%mytime%
SET foldername=%foldername::=%

@REM Create fresh directory
md bin\%foldername%\data
del /s /q bin\%foldername%

@REM Copy essential Ramen assets
copy /y  ramen\ide\data\*.*  bin\%foldername%\data

@REM Copy data and dynamic libraries
if %3=="" (
    copy /y  data\*.*  bin\%foldername%\data
) else (
    copy /y  %3\data\*.*  bin\%foldername%\data
)

@REM copy  afkit\dep\allegro5\5.2.3\*.dll  bin\%buildname%

FOR /R afkit/dep %%x IN (*.dll) DO copy "%%x" bin\%foldername% /Y 
FOR /R prg %%x IN (*.dll) DO copy "%%x" bin\%foldername% /Y 



@REM Run SwiftForth to compile and export

if %2=="" (
    sf include main.f publish bin\%foldername%\%buildname%  debug bin\%foldername%\%buildname%-debug 
) else (
    sf include %2 publish bin\%foldername%\%buildname%  debug bin\%foldername%\%buildname%-debug 
)