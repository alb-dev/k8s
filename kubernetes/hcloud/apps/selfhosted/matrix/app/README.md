# User management
To promote a existing user to admin you need to youse the mas cli
```yaml
kubectl --kubeconfig=/Users/alb/.kube/hcloud exec -it matrix-matrix-authentication-service-9658c666-5fcmh -n selfhosted -- mas-cli manage promote-admin bob
```