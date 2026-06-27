<div align="center">

# Home Operations <!-- omit in toc -->

_... managed by FluxCD, Renovate, and Forgejo Actions_ 🤖

[![Discord](https://img.shields.io/discord/673534664354430999?style=for-the-badge&label&logo=discord&logoColor=white&color=5A65EA)](https://discord.gg/k8s-at-home)
[![Renovate](https://img.shields.io/badge/Renovate-193B87?style=for-the-badge&logo=renovate&logoColor=white)](https://www.mend.io/renovate/)
[![Forgejo](https://img.shields.io/badge/Forgejo-EC622A?style=for-the-badge&logo=forgejo&logoColor=white)](https://forgejo.org)

_hcloud cluster stats:_

[![Talos](https://kromgo.albdev.cloud/badges/talos_version)](https://talos.dev)
[![Kubernetes](https://kromgo.albdev.cloud/badges/kubernetes_version)](https://kubernetes.io)
[![Flux](https://kromgo.albdev.cloud/badges/flux_version)](https://fluxcd.io)

![Age](https://kromgo.albdev.cloud/badges/cluster_age_days)
![Nodes](https://kromgo.albdev.cloud/badges/cluster_node_count)
![Pods](https://kromgo.albdev.cloud/badges/cluster_pod_count)
![CPU](https://kromgo.albdev.cloud/badges/cluster_cpu_usage)
![Memory](https://kromgo.albdev.cloud/badges/cluster_memory_usage)

</div>

--- 

</div>

## 📖 Overview
- [📖 Overview](#-overview)
- [⛵ Kubernetes](#-kubernetes)
  - [Installation](#installation)
  - [Directories](#directories)
- [☁ Cloud Dependencies](#-cloud-dependencies)
- [🔧 Hardware](#-hardware)
- [🤝 Special thanks](#-special-thanks)

# Directories

This Git repository contains the following directories under [Kubernetes](./kubernetes/).

```sh
📁 kubernetes
├── 📁 hcloud # hcloud cluster
    ├── 📁 apps # applications
    ├── 📁 components # re-useable kustomize components
    └── 📁 flux # flux system configuration    
├── 📁 home # homelab cluster
    ├── 📁 apps # applications
    ├── 📁 components # re-useable kustomize components
    └── 📁 flux # flux system configuration     
└── 📁 talos # Talos components for bootstraping nodes
```


# Handling fluxcd 
## Applying age private key secret to flux-system namespace

> [!NOTE]  
> This is needed to grant the flux-controller the possibility to decrpyt sops secrets. This includes all kustomizations managed by flux

```bash
cat $HOME/Library/Application\ Support/sops/age/keys.txt | kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin
cd bootstrap/hcloud 
sops --decrypt bootstrap/hcloud/bootstrap-secrets.sops.yaml | kubectl apply -f -
```

> [!IMPORTANT]  
> Keep in Mind that flux needs a cluster referenc with --kubeconfig=~/.kube/hcloud
## Reconcile source git repository
```bash
flux reconcile -n flux-system source git flux-system  
```
## Reconcile all kustomizations
```bash
flux reconcile -n flux-system kustomization flux-system  
```


## 🔧 Hardware

| Device                      | Num | OS Disk Size | Data Disk Size                  | Ram  | OS            | Function                |
|-----------------------------|-----|--------------|---------------------------------|------|---------------|-------------------------|
| ASUS NUC 15 Pro CU 5 225H   | 1   | 1TB SSD      | -                               | 96GB | Talos         | Kubernetes              |
| Synology RS1221+            | 1   | -            | 5x12TB btrfs (SHR-2)            | 4GB  | DSM           | NFS                     |

## 🤝 Special thanks
- [Home Operations discord community](https://discord.gg/home-operations)
- [kubesearch.dev](https://kubesearch.dev/)
- [sujiba](https://code.albdev.cloud/homelab/kops)
- [bjw-s](https://github.com/bjw-s-labs)
