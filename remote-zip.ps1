Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefolder,
    [parameter(Mandatory = $true)]
    [string]$targetfolder,
    [parameter(Mandatory = $true)]
    [string]$buildtag,
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
$targetzipfile = "$targetfolder\archive.$buildtag.$timestamp.zip"

$display_action = "Compress $sourcefolder to server $server as $targetzipfile"
$zip_block = {param($a1, $a2) Compress-Archive -Path $a1 -DestinationPath $a2}
$rm_block = {param($a1) Remove-Item -Recurse -Force $a1 }
$current_folder_dir = {param($a1) Get-ChildItem -Path  "$a1" -Recurse |Where-Object { !$_.PSIsContainer } |Sort-Object LastWriteTime -Descending }
$after_folder_clean = {param($a1, $a2) Get-ChildItem -Path  "$a1" -Recurse |Where-Object { !$_.PSIsContainer } |Sort-Object LastWriteTime -Descending |Select-Object -Skip $a2 |Remove-Item -Force -Recurse }

Write-Output $display_action

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$Session = New-PSSession -ComputerName $server -Credential $credential -SessionOption $so
Invoke-Command -Session $Session -Scriptblock $zip_block -ArgumentList $sourcefolder,$targetzipfile
Write-Output "Zip file created."
Write-Output "$(Get-Date)"
Write-Output ""
Write-Output "Deleting the source folder $sourcefolder from server $server"
Invoke-Command -Session $Session -Scriptblock $rm_block -ArgumentList $sourcefolder
Write-Output "Source folder $sourcefolder deleted."
Write-Output "$(Get-Date)"
Write-Output "Files in folder $targetfolder before rotation"
Invoke-Command -Session $Session -Scriptblock $current_folder_dir -ArgumentList $targetfolder
Write-Output ""
Write-Output "$(Get-Date)"
Invoke-Command -Session $Session -Scriptblock $after_folder_clean -ArgumentList $targetfolder,$keepnfiles
Write-Output "Files in folder $targetfolder after rotation"
Write-Output "$(Get-Date)"
Invoke-Command -Session $Session -Scriptblock $current_folder_dir -ArgumentList $targetfolder

