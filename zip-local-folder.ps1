Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefolder,
    [parameter(Mandatory = $true)]
    [string]$targetfolder,
    [parameter(Mandatory = $true)]
    [string]$zipfilename
)

$targetzipfile = "$targetfolder\$zipfilename"

$display_action = "Compress $sourcefolder to $targetzipfile"

Write-Output "$(Get-Date) $display_action"
Write-Output ""
Compress-Archive -Path $sourcefolder -DestinationPath $targetzipfile

Write-Output "$(Get-Date) Zip file created."
Write-Output ""
dir $targetzipfile

