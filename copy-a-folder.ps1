Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefolder,
    [parameter(Mandatory = $true)]
    [string]$targetfolder,
    [parameter(Mandatory = $true)]
    [string]$server,
    [parameter(Mandatory = $true)]
    [string]$user_id,
    [parameter(Mandatory = $true)]
    [SecureString]$password
)

$display_action = 'Transfer'

Write-Output $display_action

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$Session = New-PSSession -ComputerName $server -Credential $credential -SessionOption $so
Copy-Item $sourcefolder -Destination $targetfolder -ToSession $Session -Recurse
