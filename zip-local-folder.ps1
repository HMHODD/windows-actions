Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefolder,
    [parameter(Mandatory = $true)]
    [string]$targetfolder,
    [parameter(Mandatory = $true)]
    [string]$zipfilename
)

$artifactsfoldr="$targetfolder\artifacts"
$targetzipfile = "$artifactsfoldr\$zipfilename"

Write-Output "$(Get-Date) Empty artifacts foldr $artifactsfoldr"
Remove-Item -Recurse -Force $artifactsfoldr
New-Item -ItemType "directory" -Path $artifactsfoldr


$display_action = "Compress $sourcefolder to $targetzipfile"

Write-Output "$(Get-Date) $display_action"
Write-Output ""
Compress-Archive -Path $sourcefolder -DestinationPath $targetzipfile

Write-Output "$(Get-Date) Zip file created."
Write-Output ""
dir $targetzipfile

