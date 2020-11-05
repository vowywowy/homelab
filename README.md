- [get a cert-manager cloudflare api key](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens)
    - Permissions:
        - Zone - DNS - Edit
        - Zone - Zone - Read
    - Zone Resources:
        - Include - All Zones
- install cert-manager via helm
```sh
helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --set installCRDs=true \
    --set 'extraArgs={--dns01-recursive-nameservers-only,--dns01-recursive-nameservers=8.8.8.8:53\,1.1.1.1:53}'
```
