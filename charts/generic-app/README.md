# generic-app Helm Chart

This chart packages a single containerized application with a service and ingress.

## Usage

```bash
helm template my-app charts/generic-app -f ./projects/my-app/values.yaml --namespace my-app
```

Once configured, you can also push the chart as an OCI package:

```bash
helm push charts/generic-app oci://example.com/my-helm-charts
```

Create a `values.yaml` similar to the following:

```yaml
appName: sample
domainName: attyzen.com
image:
  repository: ghcr.io/your-org/app
  tag: latest
  port: 80
env:
  VAR1: value1
  VAR2: "https://{{ .Values.appName }}.{{ .Values.domainName }}"
ingress:
  host: sample.customdomain.com
```
