Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefolder,
    [parameter(Mandatory = $true)]
    [string]$targetfolder,
    [parameter(Mandatory = $true)]
    [string]$filename,
    [parameter(Mandatory = $true)]
    [string]$archivefolder,
    [parameter(Mandatory = $true)]
    [int]$keepnfiles,
    [parameter(Mandatory = $true)]
    [string]$server,
    [parameter(Mandatory = $true)]
    [string]$user_id,
    [parameter(Mandatory = $true)]
    [SecureString]$password
)

$timestamp = Get-Date -Format "yyyyMMddHHmm"
$archivezipfile = "$archivefolder\$timestamp.$filename"

$display_action = "Start transfer, unzip, arvhive and file rotation on server $server"
$unzip_file = {param($a1, $a2) Expand-Archive -LiteralPath $a1 -DestinationPath $a2}
$empty_target = {param($a1) Remove-Item -Recurse -Force $a1 }
$move_file = {param($a1, $a2) Move-Item -Path $a1 -Destination $a2 }
$current_folder_dir = {param($a1) Get-ChildItem -Path  "$a1" -Recurse |Where-Object { !$_.PSIsContainer } |Sort-Object LastWriteTime -Descending }
$after_folder_clean = {param($a1, $a2) Get-ChildItem -Path  "$a1" -Recurse |Where-Object { !$_.PSIsContainer } |Sort-Object LastWriteTime -Descending |Select-Object -Skip $a2 |Remove-Item -Force -Recurse }

Write-Output $display_action

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
Write-Output "$(Get-Date)"
$Session = New-PSSession -ComputerName $server -Credential $credential -SessionOption $so
Write-Output " Empty the target folder $targetfolder"
Write-Output "$(Get-Date)"
Invoke-Command -Session $Session -Scriptblock $empty_target -ArgumentList $targetfolder\*
Write-Output ""
Write-Output " Transfer to $targetfolder"
Write-Output "$(Get-Date)"
Copy-Item $sourcefolder\$filename -Destination $targetfolder -ToSession $Session
Write-Output ""
Write-Output " Unzip $targetfolder\$filename"
Write-Output "$(Get-Date)"
Invoke-Command -Session $Session -Scriptblock $unzip_file -ArgumentList $targetfolder\$filename,$targetfolder
Write-Output ""
Write-Output " Move it to $archivefolder"
Write-Output "$(Get-Date)"
Invoke-Command -Session $Session -Scriptblock $move_file -ArgumentList $targetfolder\$filename,$archivezipfile
Write-Output ""
Write-Output "Files in folder $targetfolder before rotation"
Write-Output "$(Get-Date)"
Invoke-Command -Session $Session -Scriptblock $current_folder_dir -ArgumentList $targetfolder
Invoke-Command -Session $Session -Scriptblock $after_folder_clean -ArgumentList $targetfolder,$keepnfiles
Write-Output ""
Write-Output "Files in folder $targetfolder after rotation"
Write-Output "$(Get-Date)"
Invoke-Command -Session $Session -Scriptblock $current_folder_dir -ArgumentList $targetfolder
Write-Output ""