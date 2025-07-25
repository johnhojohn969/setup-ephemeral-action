# setup-ephemeral-action

This repository also contains a reusable Helm chart under `charts/generic-app` for deploying a single containerized application. You can render manifests or push the chart to an OCI registry.

See `charts/generic-app/README.md` for usage and configuration details.

## Composite actions

The repository provides composite actions for use in your workflows. The
`build-and-deploy` action checks out the repository to an ephemeral workspace,
builds a Docker image and deploys it via Helm.

```yaml
- uses: johnhojohn969/setup-ephemeral-action/.github/actions/build-and-deploy@main
  with:
    project: my-app
    app-dir: ./app
    # optional: token with write access to ghcr.io (defaults to secrets.GIT_PAT)
    registry-token: ${{ secrets.GIT_PAT }}
```

The action authenticates to GHCR using the workflow trigger's username
via `github.triggering_actor` (falling back to `github.actor`).

`app-dir` defaults to `./app` and must already exist; the action does not create it automatically.
If your organization disallows the default `GITHUB_TOKEN` from publishing
packages, provide a personal access token via `registry-token`.
Override the paths if your repository uses different locations.

### Buildx Remote Build Action

Use the `buildx-remote` action to build and push a Docker image using a remote Git repository as the build context.

```yaml
- uses: johnhojohn969/setup-ephemeral-action/.github/actions/buildx-remote@main
  with:
    repository: git://github.com/johnhojohn969/your-app.git#main
    file: repo/Dockerfile
    tag: ghcr.io/${{ github.actor }}/your-app:latest
```

Provide `registry-token` if the default `GITHUB_TOKEN` cannot push to GHCR.

### Deploy Helm Chart

Use `deploy-helm` when you only need to install or upgrade one of the provided projects using the generic chart. The repository should already be checked out before calling the action.

```yaml
- uses: actions/checkout@v3
- uses: johnhojohn969/setup-ephemeral-action/.github/actions/deploy-helm@main
  with:
    project: my-app
```

The action runs:

```bash
helm upgrade --install <project> \
  oci://ghcr.io/johnhojohn969/generic-app \
  -f ./projects/<project>/values.yaml \
  --namespace <project> --create-namespace
```

See `.github/workflow-templates/buildx-and-deploy.yml` for a workflow using this action together with `buildx-remote`.

### Package and Push Helm Chart

Use `helm-push` to package the generic chart and upload it to an OCI registry.

```yaml
- uses: ./.github/actions/helm-push
  with:
    chart-path: charts/generic-app
    registry: oci://ghcr.io/your-user/generic-app
```

### Push Chart Workflow

Use the `Push Generic Chart` workflow to automatically package and publish the chart to GHCR whenever files under `charts/generic-app` change.
See `.github/workflows/push-generic-chart.yml` for details.
