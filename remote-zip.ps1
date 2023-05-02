Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefolder,
    [parameter(Mandatory = $true)]
    [string]$targetzip,
    [parameter(Mandatory = $true)]
    [string]$server,
    [parameter(Mandatory = $true)]
    [string]$user_id,
    [parameter(Mandatory = $true)]
    [SecureString]$password
)

$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
$targetzipfile = "$targetzip.$timestamp.zip"

$display_action = "Compress $sourcefolder to server $server as $targetzipfile"
$script_block = {param($a1, $a2) Compress-Archive -Path $a1 -DestinationPath $a2}
$arguments = "$sourcefolder, $targetzipfile"
Write-Output $display_action

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$Session = New-PSSession -ComputerName $server -Credential $credential -SessionOption $so
Invoke-Command -Session $Session -Scriptblock $script_block -ArgumentList $arguments
Remove-PSSession $Session

Write-Output "Zip file created."

