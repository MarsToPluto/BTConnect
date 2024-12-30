@echo off
:: Check if PowerShell is available
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    echo PowerShell is not installed. Please install it to proceed.
    exit /b 1
)

:: Invoke the PowerShell script
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { .\ListAndConnectBluetooth.ps1 }"
