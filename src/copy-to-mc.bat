@echo off
title copy-to-mc -- cmdpwnd
set p=%~dp0
cd /d %p%
echo.
echo pwd: %p%
echo.
set /p world=[world]:
set /p id=[computerID]:
echo "%appdata%\.minecraft\saves\%world%\computer\%id%\" >nul
del /s /q "%appdata%\.minecraft\saves\%world%\computer\%id%\interface" >nul
del /s /q "%appdata%\.minecraft\saves\%world%\computer\%id%\pm" >nul
copy /y /v interface.lua "%appdata%\.minecraft\saves\%world%\computer\%id%\" >nul
copy /y /v pm.lua "%appdata%\.minecraft\saves\%world%\computer\%id%\" >nul
rename "%appdata%\.minecraft\saves\%world%\computer\%id%\interface.lua" interface >nul 
rename "%appdata%\.minecraft\saves\%world%\computer\%id%\pm.lua" pm >nul
echo Done.
echo.
pause
ping ::1 -n 1 >nul
@echo on