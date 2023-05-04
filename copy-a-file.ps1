Param(
    [parameter(Mandatory = $true)]
    [string]$sourcefile,
    [parameter(Mandatory = $true)]
    [string]$targetfolder,
    [parameter(Mandatory = $true)]
    [string]$server,
    [parameter(Mandatory = $true)]
    [string]$user_id,
    [parameter(Mandatory = $true)]
    [SecureString]$password
)

$display_action = "Transfer $sourcefile to server $server under $targetfolder"

Write-Output $display_action

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$Session = New-PSSession -ComputerName $server -Credential $credential -SessionOption $so
Copy-Item $sourcefile -Destination $targetfolder -ToSession $Session -Recurse

Write-Output "File transfered."