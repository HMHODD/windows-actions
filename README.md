# windows-actions

------

## Inputs

| Parameter                  | Is Required | Description                                       |
| -------------------------- | ----------- | ------------------------------------------------- |
| `action`                   | true        | Specify start, stop, or restart action to perform |
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
      - name: IIS stop
        uses: <ORG_NAME>/windows-actions@iis-action
        with:
        action: 'stop'
          server: ${{ env.server }}
          service-account-id: ${{ secrets.iis_admin_user }}
          service-account-password: ${{ secrets.iis_admin_password }}
...
```

------