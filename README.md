<div align="center">

# My Home Operations Repository <!-- omit in toc -->

_... managed by fluxcd, Renovate, and Forgejo Actions_ 🤖

<div align="center">

[![Discord](https://img.shields.io/discord/673534664354430999?style=for-the-badge&label&logo=discord&logoColor=white&color=blue)](https://discord.gg/home-operations)&nbsp;&nbsp;
[![Talos](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Ftalos_version&style=for-the-badge&logo=talos&logoColor=white&color=blue&label=%20)](https://talos.dev)&nbsp;&nbsp;
[![Kubernetes](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fkubernetes_version&style=for-the-badge&logo=kubernetes&logoColor=white&color=blue&label=%20)](https://kubernetes.io)&nbsp;&nbsp;
[![Flux](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fflux_version&style=for-the-badge&logo=flux&logoColor=white&color=blue&label=%20)](https://fluxcd.io)&nbsp;&nbsp;

</div>

<div align="center">

[![Age-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fcluster_age_days&style=flat-square&label=Age)](https://github.com/kashalls/kromgo)&nbsp;&nbsp;
[![Uptime-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fcluster_uptime_days&style=flat-square&label=Uptime)](https://github.com/kashalls/kromgo)&nbsp;&nbsp;
[![Node-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fcluster_node_count&style=flat-square&label=Nodes)](https://github.com/kashalls/kromgo)&nbsp;&nbsp;
[![Pod-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fcluster_pod_count&style=flat-square&label=Pods)](https://github.com/kashalls/kromgo)&nbsp;&nbsp;
[![CPU-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fcluster_cpu_usage&style=flat-square&label=CPU)](https://github.com/kashalls/kromgo)&nbsp;&nbsp;
[![Memory-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fcluster_memory_usage&style=flat-square&label=Memory)](https://github.com/kashalls/kromgo)&nbsp;&nbsp;
[![Alerts](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.onji.space%2Fcluster_alert_count&style=flat-square&label=Alerts)](https://github.com/kashalls/kromgo)

</div>

---

👋 Welcome to my repository. This is a mono repository for my home-, cloud infrastructure and Kubernetes cluster. I try to adhere to Infrastructure as Code (IaC) and GitOps practices using the tools like [Kubernetes](https://kubernetes.io/), [Flux](https://github.com/fluxcd/flux2), [Renovate](https://docs.renovatebot.com/) and [Forgejo Actions](https://forgejo.org/docs/latest/user/actions/reference/).

--- 

</div>

## 📖 Overview
- [📖 Overview](#-overview)
- [⛵ Kubernetes](#-kubernetes)
  - [Installation](#installation)
  - [Directories](#directories)
  - [Networking](#networking)
- [☁ Cloud Dependencies](#-cloud-dependencies)
- [🔧 Hardware](#-hardware)
- [🤝 Special thanks](#-special-thanks)



# GitOps

[Flux](https://github.com/fluxcd/flux2) watches the clusters in my [kubernetes](./kubernetes/) folder (see Directories below) and makes the changes to my clusters based on the state of my Git repository.

The way Flux works for me here is it will recursively search the `kubernetes/clustername/apps` folder until it finds the most top level `kustomization.yaml` per directory and then apply all the resources listed in it. That aforementioned `kustomization.yaml` will generally only have a namespace resource and one or many Flux kustomizations (`ks.yaml`). Under the control of those Flux kustomizations there will be a `HelmRelease` or other resources related to the application which will be applied.

[Renovate](https://github.com/renovatebot/renovate) watches my **entire** repository looking for dependency updates, when they are found a PR is automatically created. When some PRs are merged Flux applies the changes to my cluster.


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


# Hnadling fluxcd 
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


# 🤝 Special thanks
- [Home Operations discord community](https://discord.gg/home-operations)
- [kubesearch.dev](https://kubesearch.dev/)
- [sujiba](https://code42.next.offene.cloud/homelab/k8s.git)
- [bjw-s](https://github.com/bjw-s-labs)