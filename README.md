# windows-actions

------

## Inputs

| Parameter                  | Is Required | Description                                       |
| -------------------------- | ----------- | ------------------------------------------------- |
| `sourcefolder`             | true        | Specify source artifacts folder on runner         |
| `targetfolder`             | true        | Specify target folder on remote server            |
| `filename`                 | true        | Source zip file name                              |
| `archivefolder`            | true        | Specify archive folder on remote server           |
| `keepnfiles`               | true        | Specify number of archives to keep                |
| `server`                   | true        | The name of the target server                     |
| `service-account-id`       | true        | The service account name                          |
| `service-account-password` | true        | The service account password                      |

------

## Example
```yml
...

jobs:
  transfer-unzip-archive:
    runs-on: [windows-2019, self-hosted]

    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Transfer artifact zip to remote server, unzip and archive
        uses: <ORGNAME>/windows-actions@transfer-unzip-archive
        with:
          sourcefolder: ${{ github.workspace }}
          filename: T_${{ github.run_number }}_${{ github.run_id }}.zip
          targetfolder: 'C:\output'
          archivefolder: 'C:\archive'
          keepnfiles: 5
          server: ${{ vars.SERVER }}
          service-account-id: ${{ secrets.IIS_ADMIN_USER }}
          service-account-password: ${{ secrets.IIS_ADMIN_PASSWORD }}
      

...
```

------