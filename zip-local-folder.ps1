Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefolder,
    [parameter(Mandatory = $true)]
    [string]$targetfolder,
    [parameter(Mandatory = $true)]
    [string]$targetfilename
)

$timestamp = Get-Date -Format "yyyyMMddHHmm"
$targetzipfile = "$targetfolder\$targetfilename"

$display_action = "Compress $sourcefolder to $targetzipfile"

Write-Output $display_action
Write-Output "$(Get-Date)"

Compress-Archive -Path $sourcefolder -DestinationPath $targetzipfile

Write-Output "Zip file created."
Write-Output "$(Get-Date)"
Write-Output ""
dir $targetzipfile

