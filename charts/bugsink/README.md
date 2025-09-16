# Bugsink Helm Chart

- Installs the [Bugsink](https://www.bugsink.io/) error monitoring service.

## Get Repo Info

```console
helm repo add victorlane https://victorlane.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release victorlane/bugsink
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

Key settings (see `values.yaml` for the full list):

- `bugsink.image.repository`: image repo (default `bugsink/bugsink`)
- `bugsink.image.tag`: image tag (default `2`)
- `bugsink.image.pullPolicy`: image pull policy
- `bugsink.image.pullSecrets`: list of imagePullSecrets names to use
- `bugsink.replicas`: number of replicas
- `bugsink.env`: environment variables like `PORT`, `BASE_URL`
- `bugsink.secrets`: optionally source sensitive envs from existing Secrets
- `bugsink.mariadb.*`: enable and configure bundled MariaDB

## Example usage

To override values, use a custom `values.yaml` or `--set` flag:

```console
helm install my-release victorlane/bugsink \
  --set bugsink.replicas=2,bugsink.image.tag=2
```

### Using private registries

Create a Docker registry secret in your namespace:

```console
kubectl create secret docker-registry harbor-bmlabs \
  --docker-server=harbor.bmlabs.eu \
  --docker-username=<user> \
  --docker-password='<pass>' \
  --docker-email='<email>'
```

Reference it via values:

```yaml
bugsink:
  image:
    pullSecrets:
      - harbor-bmlabs
```

## Persistence

By default, Bugsink does not persist data.

## Ingress

To enable ingress, set `ingress.enabled: true` and configure hosts and paths as needed.

## Security

You can set environment variables for authentication and other security features via the `env` section in `values.yaml`.

---

For more details, see the [Bugsink documentation](https://docs.bugsink.io/).
