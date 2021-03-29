# Requirements
- An ingress controller - here is nginx as an example:
```sh
helm install ingress-nginx nginx-stable/nginx-ingress \
    --namespace ingress-nginx \
    --create-namespace
```
- cert-manager
```sh
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
- If
- Add this repo as a helm chart and install it
```sh
helm repo add homelab https://raw.githubusercontent.com/vowywowy/homelab/master/chart
helm repo update
helm install homelab/homelab
    --set
```
