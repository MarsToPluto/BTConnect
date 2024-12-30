# Function to list paired devices with MAC addresses and save them to JSON
function List-PairedBluetoothDevices {
    Write-Output "Paired Bluetooth Devices (Name and MAC Address):"

    # Get all Bluetooth devices
    $devices = Get-PnpDevice | Where-Object { $_.Class -eq "Bluetooth" -and $_.Status -eq "OK" }

    $deviceList = @()

    foreach ($device in $devices) {
        $deviceName = $device.FriendlyName
        # Extract MAC Address from the DeviceID
        $macAddress = ($device.InstanceId -split "&")[-1] -replace "_", ":"
        Write-Output "$deviceName - $macAddress"

        # Add device information to the list
        $deviceList += [PSCustomObject]@{
            Name = $deviceName
            MACAddress = $macAddress
        }
    }

    # Save the device list to a JSON file
    $jsonFilePath = "BluetoothDevices.json"
    $deviceList | ConvertTo-Json -Depth 2 | Set-Content -Path $jsonFilePath
    Write-Output "Device information saved to $jsonFilePath"
}

# Function to connect to a specific device using MAC address
function Connect-BluetoothDevice {
    param (
        [string]$MacAddress
    )

    $devices = Get-PnpDevice | Where-Object { $_.Class -eq "Bluetooth" -and $_.Status -eq "OK" }
    $selectedDevice = $devices | Where-Object { 
        ($_.InstanceId -split "&")[-1] -replace "_", ":" -eq $MacAddress 
    }

    if ($selectedDevice) {
        Write-Output "Attempting to connect to the device with MAC Address: $MacAddress..."
        Start-Process "devcon.exe" -ArgumentList "enable", $selectedDevice.InstanceId -NoNewWindow -Wait
        Write-Output "Connection initiated. Check the device for status."
    } else {
        Write-Output "Device with MAC Address '$MacAddress' not found among paired devices."
    }
}

# Main script execution
List-PairedBluetoothDevices

# Ask the user for the MAC address of the device to connect to
$macAddressToConnect = Read-Host "Enter the MAC Address of the device to connect to"
Connect-BluetoothDevice -MacAddress $macAddressToConnect
