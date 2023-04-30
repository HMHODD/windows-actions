Param(
    [parameter(Mandatory = $true)]
    [ValidateSet( 'start', 'stop', 'restart')]
    [string]$action,
    [parameter(Mandatory = $true)]
    [string]$server,
    [parameter(Mandatory = $true)]
    [string]$user_id,
    [parameter(Mandatory = $true)]
    [SecureString]$password
)

$display_action = 'IIS'
$title_verb = (Get-Culture).TextInfo.ToTitleCase($action)

$display_action += " $title_verb"
$past_tense = "ed"
switch ($action) {
    "start" {}
    "restart" { break; }
    "stop" { $past_tense = "ped"; break; }
}
$display_action_past_tense = "$display_action$past_tense"

Write-Output $display_action

$credential = [PSCredential]::new($user_id, $password)
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$script = {
    switch ($Using:action) {
        'stop' {
            IISReset /STOP
            break
        }
        'start' {
            IISReset /START
            break
        }
        'restart' {
            IISReset /RESTART
            break
        }
    }
}

Invoke-Command -ComputerName $server `
    -Credential $credential `
    -SessionOption $so `
    -ScriptBlock $script

Write-Output "$display_action_past_tense."
