# Golee Build Action Workflow

In order not to subscribe to the enterprise version of GitHub we publish our template actions here ;)

Usage

```
- name: Build
        uses: GoleeTeam/golee-build-action-workflow@v0.36-test
        with:
          name: ${{ github.repository }}
          branch: ${{ github.ref }}
          commit_hash: ${{ github.sha }}
        env:
          GCLOUD_SERVICE_ACCOUNT_KEYFILE: ${{ secrets.GCP_GCR_BUILD_SERVICE_ACCOINT_KEY }}
          GCLOUD_PROJECT: "golee-infra"
```
