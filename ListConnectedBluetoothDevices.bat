@echo off
:: Set the path to the PowerShell script
set "PowerShellScript=ListConnectedBluetoothDevices.ps1"

:: Check if the PowerShell script exists
if not exist "%PowerShellScript%" (
    echo The PowerShell script '%PowerShellScript%' was not found.
    pause
    exit /b
)

:: Run the PowerShell script
echo Running the PowerShell script to list connected Bluetooth devices...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PowerShellScript%"

:: Check if the JSON file was created
if exist "ConnectedBluetoothDevices.json" (
    echo The JSON file 'ConnectedBluetoothDevices.json' has been created successfully.
    echo You can open it to view the list of connected Bluetooth devices.
) else (
    echo The JSON file 'ConnectedBluetoothDevices.json' was not created. Please check for errors.
)

pause
