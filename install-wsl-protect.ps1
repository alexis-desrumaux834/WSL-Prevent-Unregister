# PowerShell script to add WSL functions to user profile
$profileScript = @"
function wsl {
    [CmdletBinding(PositionalBinding=`$false)]
    param(
        [Parameter(ValueFromRemainingArguments = `$true)]
        [string[]]`$Params
    )

    # Check for presence of --unregister
    `$containsUnregister = `$Params -contains '--unregister'
    # Check for presence of the bypass flag
    `$containsForceDelete = `$Params -contains '--delete-i-know-what-i-am-doing'

    if (`$containsUnregister -and -not `$containsForceDelete) {	
        Write-Host 'WARNING: You are about to delete a WSL distribution.' -ForegroundColor Yellow
        Write-Host 'This operation will permanently erase all data within the specified distribution.' -ForegroundColor Yellow
        Write-Host ''
        wsl --list
        `$confirmation = Read-Host 'Do you wish to proceed? (yes/no)'
        if (`$confirmation.ToLower() -ne 'yes') {
            Write-Host 'Operation cancelled: Deletion aborted by user.' -ForegroundColor Cyan
            return
        }
    }

    # Optional: remove the bypass flag before the call
    `$filteredParams = `$Params | Where-Object { `$_ -ne '--delete-i-know-what-i-am-doing' }

    & 'wsl.exe' `$filteredParams
}
"@

# Verify and create profile directory if missing
$profileDir = Split-Path -Path $PROFILE -Parent
if (!(Test-Path -Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-Host "Profile directory created successfully." -ForegroundColor Green
}

# Add functions to profile with content preservation
if (!(Test-Path -Path $PROFILE)) {
    $profileScript | Out-File -FilePath $PROFILE -Encoding utf8
    Write-Host "PowerShell profile initialized"
} else {
    $existingContent = Get-Content -Path $PROFILE -Raw
    if ($existingContent -notmatch 'function wsl\s?\(') {
        # Ensure proper line spacing before appending
        $contentToAdd = if ($existingContent.EndsWith("`n")) { $profileScript } else { "`n$profileScript" }
        Add-Content -Path $PROFILE -Value $contentToAdd -Encoding utf8
        Write-Host "WSL management functions added to existing profile." -ForegroundColor Green
    } else {
        Write-Host "WSL management functions already present in profile." -ForegroundColor Yellow
    }
}

Write-Host "Configuration complete. To ensure WSL protection is enabled and the related commands are available, please restart all open PowerShell terminals." -ForegroundColor Green