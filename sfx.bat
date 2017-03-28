@echo off

set PATH=%PATH%;%CD%\utilities
set PATH=%PATH%;%ProgramFiles%\WinRar

for /f "tokens=1,2 delims=	" %%i in ('filever /v "dou.exe"^|find /i "FileVersion"') do (
	set VERSION_STRING=%%j
)
echo The current version of the product is %VERSION_STRING%
echo.

echo Create an readme.txt file...
copy /y "info.txt" "readme.txt"
rplstr -s:"{VERSION_STRING}" -r:"%VERSION_STRING%" "readme.txt"
rplstr -s:"{DATE_STRING}" -r:"%DATE%" "readme.txt"

echo Create an SFX script file...
echo ;������������� ���� ����������� �������� ������� SFX-��������>sfx.opt
echo.>>sfx.opt
echo Path=Deus Offline Updater>>sfx.opt
echo Presetup=taskkill /im dou.exe /f>>sfx.opt
echo Setup=dou.exe /installed>>sfx.opt
echo SetupCode>>sfx.opt
echo Overwrite=^1>>sfx.opt
echo Title=Deus Offline Updater v%VERSION_STRING%>>sfx.opt
echo Text>>sfx.opt
echo {>>sfx.opt
setlocal EnableDelayedExpansion
for /f "delims=" %%i in (readme.txt) do (
	set line=%%i
	set line=!line: =!
	if not "!line!"=="" (
	 	echo %%i>>sfx.opt
	)
	echo.>>sfx.opt
)
setlocal DisableDelayedExpansion
echo }>>sfx.opt
echo Shortcut=D, dou.exe, , , "Deus Offline Updater", >>sfx.opt
echo Shortcut=P, dou.exe, "Deus Offline Updater", , "Deus Offline Updater", >>sfx.opt
echo Shortcut=P, settings.exe, "Deus Offline Updater", , Settings, >>sfx.opt

echo Create an SFX archive...
del /q "sfx.exe"
winrar a -ibck -iadm -inul -sfx -iiconsfx.ico -iimgsfx.bmp -zsfx.opt sfx @sfx.lst
del /q "readme.txt"
del /q "sfx.opt"
echo.

echo Done!
pause
