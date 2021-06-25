# Requirements
- Nginx ingress controller:
```sh
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace
```
- cert-manager
```sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --set installCRDs=true \
    --set 'extraArgs={--dns01-recursive-nameservers-only,--dns01-recursive-nameservers=8.8.8.8:53\,1.1.1.1:53}'
```
- [A cert-manager cloudflare api key](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens)
    - Permissions:
        - Zone - DNS - Edit
        - Zone - Zone - Read
    - Zone Resources:
        - Include - All Zones
# Install
- Add this repo as a helm chart
```sh
helm repo add homelab https://vowywowy.github.io/homelab/
helm repo update
```
- Read values.yaml and deploy as desired. For example, this exactly what I use for values.yaml
```yaml
cloudflare:
  apiKey: <cf api key>
  email: <email>

letsEncrypt:
  email: < email>
  production: true

domain: app.lan.rip

mediaPersistence:
  enabled: true
  type: hostPath

apps:
  oauth2proxy:
    users:
    - vowywowy
    secret:
      clientID: <oauth id>
      clientSecret: <oauth secret>
```
