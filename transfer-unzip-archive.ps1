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
$Session = New-PSSession -ComputerName $server -Credential $credential -SessionOption $so
Write-Output "$(Get-Date) Empty the target folder $targetfolder"
Invoke-Command -Session $Session -Scriptblock $empty_target -ArgumentList $targetfolder\*
Write-Output ""
Write-Output "$(Get-Date) Transfer to $targetfolder"
Copy-Item $sourcefolder\$filename -Destination $targetfolder -ToSession $Session
Write-Output ""
Write-Output "$(Get-Date) Unzip $targetfolder\$filename"
Invoke-Command -Session $Session -Scriptblock $unzip_file -ArgumentList $targetfolder\$filename,$targetfolder
Write-Output ""
Write-Output "$(Get-Date) Move it to $archivefolder"
Invoke-Command -Session $Session -Scriptblock $move_file -ArgumentList $targetfolder\$filename,$archivezipfile
Write-Output ""
Write-Output "$(Get-Date) Files in folder $targetfolder before rotation"
Invoke-Command -Session $Session -Scriptblock $current_folder_dir -ArgumentList $archivefolder
Invoke-Command -Session $Session -Scriptblock $after_folder_clean -ArgumentList $archivefolder,$keepnfiles
Write-Output "$(Get-Date) Files in folder $targetfolder after rotation"
Invoke-Command -Session $Session -Scriptblock $current_folder_dir -ArgumentList $archivefolder
Write-Output ""
Write-Output "File transfer, unzip and archive completed"