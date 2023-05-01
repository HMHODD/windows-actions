# windows-actions

------

## Inputs

| Parameter                  | Is Required | Description                                       |
| -------------------------- | ----------- | ------------------------------------------------- |
| `sourcefolder`             | true        | Specify source artifacts folder                   |
| `targetfolder`             | true        | Specify target folder on remote server            |
| `server`                   | true        | The name of the target server                     |
| `service-account-id`       | true        | The service account name                          |
| `service-account-password` | true        | The service account password                      |

------

## Example
```yml
...

jobs:
  stop-iis-service:
    runs-on: [windows-2019, self-hosted]
    env:
      server: 'web01.domain.com'

    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Copy Artifacts folder to remote server
        uses: <ORGNAME>/windows-actions@copy-a-folder
        with:
          sourcefolder: 'artifacts'
          targetfolder: 'C:\output\'
          server: ${{ vars.SERVER }}
          service-account-id: ${{ secrets.IIS_ADMIN_USER }}
          service-account-password: ${{ secrets.IIS_ADMIN_PASSWORD }}
      

...
```

------