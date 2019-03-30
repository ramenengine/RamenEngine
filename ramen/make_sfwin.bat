REM params: <buildname> <main.f> <projectpath>
SETLOCAL

if %1=="" (
    SET buildname=build
) else (
    SET buildname=%1
)

@REM Create fresh directory
md bin\%buildname%\data
del /s /q bin\%buildname%

@REM Copy essential Ramen assets
copy /y  ramen\ide\data\*.*  bin\%buildname%\data

@REM Copy data and dynamic libraries
if %3=="" (
    copy /y  data\*.*  bin\%buildname%\data
) else (
    copy /y  %3\data\*.*  bin\%buildname%\data
)

@REM copy  afkit\dep\allegro5\5.2.3\*.dll  bin\%buildname%

FOR /R afkit/dep %%x IN (*.dll) DO copy "%%x" bin\%buildname% /Y 
FOR /R prg %%x IN (*.dll) DO copy "%%x" bin\%buildname% /Y 

@REM Run SwiftForth to compile and export
if %2=="" (
    sf include main.f publish bin\%buildname%\%buildname%
) else (
    sf include %2 publish bin\%buildname%\%buildname%
)


