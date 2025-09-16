# Browserless Helm Chart

- Installs the [Browserless](https://www.browserless.io/) service for headless browser automation.

## Get Repo Info

```console
helm repo add victorlane https://victorlane.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release victorlane/browserless
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an incompatible breaking change needing manual actions.

## Configuration

The following table lists the configurable parameters of the Browserless chart and their default values. See `values.yaml` for the full list.

| Parameter          | Description                          | Default              |
| ------------------ | ------------------------------------ | -------------------- |
| `replicaCount`     | Number of browserless pods           | `1`                  |
| `image.repository` | Image repository                     | `browserless/chrome` |
| `image.tag`        | Image tag                            | `latest`             |
| `service.type`     | Kubernetes service type              | `ClusterIP`          |
| `service.port`     | Service port                         | `3000`               |
| `resources`        | CPU/Memory resource requests/limits  | `{}`                 |
| `nodeSelector`     | Node labels for pod assignment       | `{}`                 |
| `tolerations`      | Toleration labels for pod assignment | `[]`                 |
| `affinity`         | Affinity settings for pod assignment | `{}`                 |

_See `values.yaml` for all available configuration options._

## Example usage

To override values, use a custom `values.yaml` or `--set` flag:

```console
helm install my-release victorlane/browserless \
  --set replicaCount=2,image.tag=1.56-chrome-stable
```

## Persistence

By default, Browserless does not persist data. To enable persistence, configure the `persistence` section in `values.yaml`.

## Ingress

To enable ingress, set `ingress.enabled: true` and configure hosts and paths as needed.

## Security

You can set environment variables for authentication and other security features via the `env` section in `values.yaml`.

---

For more details, see the [Browserless documentation](https://docs.browserless.io/).
