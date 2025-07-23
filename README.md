# setup-ephemeral-action

This repository also contains a reusable Helm chart under `charts/generic-app` for deploying a simple backend and frontend application. You can render manifests or push the chart to an OCI registry.

See `charts/generic-app/README.md` for usage and configuration details.

## Composite actions

The repository provides composite actions for use in your workflows. The
`build-and-deploy` action checks out the repository to an ephemeral workspace,
builds backend and frontend Docker images and deploys them via Helm.

```yaml
- uses: johnhojohn969/setup-ephemeral-action/.github/actions/build-and-deploy@main
  with:
    project: my-app
    backend-dir: ./app
    frontend-dir: ./frontend
    # optional: token with write access to ghcr.io
    registry-token: ${{ secrets.GHCR_TOKEN }}
```

`backend-dir` and `frontend-dir` default to `./app` and `./frontend`.
These folders must already exist; the action does not create them automatically.
If your organization disallows the default `GITHUB_TOKEN` from publishing
packages, provide a personal access token via `registry-token`.
Override the paths if your repository uses different locations.
