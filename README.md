# windows-actions

------

## Inputs

| Parameter                  | Is Required | Description                                       |
| -------------------------- | ----------- | ------------------------------------------------- |
| `sourcefolder`             | true        | Specify artifacts folder name on runner           |
| `targetfolder`             | true        | Target folder to store compressed artifacts       |
| `zipfilename`              | true        | The zip file name                                 |

------

## Example
```yml
...

jobs:
  deployment:
    runs-on: [windows-2019, self-hosted]

    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Comparess the artifacts folder on runner
        uses: <ORGNAME>/windows-actions@main-zip-local-folder
        with:
          sourcefolder: 'artifacts'
          targetfolder: ${{ github.workspace }}
          zipfilename: T_${{ github.run_number }}_${{ github.run_id }}.zip


...
```

------
