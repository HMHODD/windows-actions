# windows-actions

------

## Inputs

| Parameter                  | Is Required | Description                                                                  |
| -------------------------- | ----------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------- | ---- | ----- |
| `script-path`              | true        | The local repository path to the script to be executed on the remote machine |
| `script-arguments`         | false       | A pipe delimited string, `|`, that contains the arguments for the script - Example: `arg1 | arg2 | arg3` |
| `server`                   | true        | The name of the target server                                                |
| `service-account-id`       | true        | The service account name                                                     |
| `service-account-password` | true        | The service account password                                                 |

------

## Example

```yml
...

jobs:
  execute-remote-script:
   runs-on: [windows-2019, self-hosted]
   steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Execute Script
      uses: <ORGNAME>/windows-actions@vremote-powershell-run
      with:
        script-path: './execute-script.ps1'
        script-arguments:  'arg1|arg2|arg3'
        server: ${{ vars.server }}
        service-account-id: ${{ secrets.iis_admin_user }}
        service-account-password: ${{ secrets.iis_admin_password }}
  ...
```

------