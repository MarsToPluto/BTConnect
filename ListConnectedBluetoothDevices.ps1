# Function to list actively connected Bluetooth devices
function List-ConnectedBluetoothDevices {
    Write-Output "Fetching actively connected Bluetooth devices..."

    # Get all Bluetooth devices
    $bluetoothDevices = Get-PnpDevice | Where-Object { $_.Class -eq "Bluetooth" }

    # Filter for actively connected devices
    $connectedDevices = $bluetoothDevices | Where-Object {
        # Checking if the device is marked as connected
        $_.Status -eq "OK" -and $_.FriendlyName -ne $null -and $_.InstanceId -match "BTHENUM"
    }

    # Prepare the JSON structure
    $devicesList = @()
    foreach ($device in $connectedDevices) {
        $deviceName = $device.FriendlyName

        # Extract MAC Address from the DeviceID
        $macAddress = ($device.InstanceId -split "&")[-1] -replace "_", ":"

        # Add to list
        $devicesList += @{
            Name = $deviceName
            MACAddress = $macAddress
        }
    }

    # Save as JSON
    $jsonPath = "ConnectedBluetoothDevices.json"
    $devicesList | ConvertTo-Json -Depth 3 | Out-File -FilePath $jsonPath -Encoding utf8
    Write-Output "Actively connected devices saved to $jsonPath"
}

# Main execution
List-ConnectedBluetoothDevices
