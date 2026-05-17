- [Required packages](#required-packages)
- [Prerequisites](#prerequisites)
  - [Namespaces + required Bootstrap secrets](#Create-Namespaces-for-flux-and-forgejo)
  - [Deploy AGE Key](#Add-Private-key-for-decryption-with-flux)
  - [Prepare k8s for bootstrap](#prepare-k8s-for-bootstrap)
- [Bootstrap k8s cluster with fluxcd](#bootstrap-flux-and-cluster-components)


# Required packages
```bash
brew install helm helmfile kubectl fluxcd/tap/flux
```

# Prerequisites
--- 

> [!IMPORTANT]  
> Since we got a chicken and egg problem. We need to have components of forgejo in place before flux can take over

# Create Namespaces for flux and forgejo
```bash
kubectl create namespace flux-system
sops --decrypt kubernetes/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
kubectl apply -f kubernetes/flux/vars/cluster-settings.yaml
```


# Add Private key for decryption with flux 
```bash
cat $HOME/Library/Application\ Support/sops/age/keys.txt | kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin    
```


### bootstrap flux and cluster components
```bash
# initiate helmfile
helmfile init

# render all necessary crds
helmfile -f 00-crds.yaml template -q | kubectl apply --server-side -f -

# sync helm
helmfile -f 1-apps.yaml sync
```

Troubleshooting
```bash
flux get all -A --status-selector ready=false --kubeconfig ~/.kube/home

flux get helmreleases --all-namespaces --watch --kubeconfig ~/.kube/home

flux logs --all-namespaces --follow --level=error
```