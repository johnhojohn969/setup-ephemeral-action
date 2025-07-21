# generic-app Helm Chart

This chart packages a simple backend and frontend application with ingress and runtime environment `env.js` support.

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
  backend:
    repository: ghcr.io/your-org/backend
    tag: latest
    port: 8002
  frontend:
    repository: ghcr.io/your-org/frontend
    tag: latest
    port: 80
env:
  backend:
    VAR1: value1
    VAR2: "https://{{ .Values.appName }}.{{ .Values.domainName }}"
  frontend:
    VITE_API_BASE: "https://{{ .Values.appName }}-service.{{ .Values.domainName }}"
ingress:
  frontendHost: frontend.customdomain.com
  backendHost: backend.customdomain.com
```
