$validInput = $false
while ($validInput -eq $false) {
    Write-Host "Please select a Windows 10 version to download:"
    Write-Host "1. Version 22H2"
    Write-Host "2. Version 21H2"
    Write-Host "3. Version 20H2"
    Write-Host "4. Version 1909"
    Write-Host "5. Version 1803"

    $input = Read-Host -Prompt "Enter a number (1-5)"

    if ($input -in 1..5) {
        $validInput = $true
    }
}

$downloadUrl = switch ($input) {
    1 {
        "https://software-download.microsoft.com/download/pr/19044.1288.2109041610.co_release_svc_prod1_Windows10_InsiderPreview_Client_x64_en-us.iso"
    }
    2 {
        "https://software-download.microsoft.com/download/pr/19044.1288.2109041610.co_release_svc_prod1_Windows10_InsiderPreview_Client_x64_en-us.iso"
    }
    3 {
        "https://software-download.microsoft.com/download/pr/19042.804.2102183152.co_release_svc_prod1_Windows10_InsiderPreview_Client_x64_en-us.iso"
    }
    4 {
        "https://software-download.microsoft.com/download/pr/18363.476.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
    }
    5 {
        "https://software-download.microsoft.com/download/pr/17134.1.180410-1804.rs4_release_clientbusiness_vol_x64fre_en-us_2cddb565.iso"
    }
}

$drive = $null
while ($drive -eq $null) {
    $availableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object -ExpandProperty DeviceID
    Write-Host "Please select the destination drive for the download:"

    for ($i = 0; $i -lt $availableDrives.Count; $i++) {
        Write-Host "$($i+1). $($availableDrives[$i])"
    }

    $driveInput = Read-Host -Prompt "Enter a number (1-$($availableDrives.Count))"
    if ($driveInput -in 1..$availableDrives.Count) {
        $drive = $availableDrives[$driveInput - 1]
    }
}

$destinationFolder = Read-Host -Prompt "Enter a folder name for the Windows 10 version on $($drive):"
$destinationFolder = Join-Path $drive $destinationFolder

if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

$destinationFile = Join-Path $destinationFolder "Windows10Version$($input).iso"

try {
    Invoke-WebRequest $downloadUrl -OutFile $destinationFile -ErrorAction Stop
    Write-Host "Download complete! File saved at $($destinationFile)"
} catch {
    if ($_.Exception.Response.StatusCode.Value__ -eq 404) {
        Write-Host "Error: The URL cannot be found."
    } else {
        Write-Host "Error: $_"
    }
}
