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
        "https://software-download.microsoft.com/download/pr/18363.1198.2106120046.rs_x64fre_client_en-us_retail_64e68469.iso"
    }
    5 {
        "https://software-download.microsoft.com/download/pr/17134.1.190411-0538.rs4_release_clientbusiness_vol_x64fre_en-us_8a2a278f9589cde83d0ddc7208b5017b6cabbffb.iso"
    }
}

$destinationFolder = $null
while ($destinationFolder -eq $null) {
    $selectedFolder = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Select download location", 0, "C:\")
    if ($selectedFolder -ne $null) {
        $destinationFolder = $selectedFolder.Self.Path
    } else {
        Write-Host "Error: Please select a download location."
    }
}

$destinationFile = Join-Path $destinationFolder "Windows10Version$($input).iso"

try {
    Invoke-WebRequest $downloadUrl -OutFile $destinationFile -ErrorAction Stop
    Write-Host "Download complete!"
} catch {
    if ($_.Exception.Response.StatusCode.Value__ -eq 404) {
        Write-Host "Error: The URL cannot be found."
    } else {
        Write-Host "Error: $_"
    }
}

