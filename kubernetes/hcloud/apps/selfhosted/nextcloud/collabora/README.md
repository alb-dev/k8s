If autoscaling is needed


```yaml
    defaultPodOptions:
      topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: kubernetes.io/hostname
          whenUnsatisfiable: ScheduleAnyway
          labelSelector:
            matchLabels:
              app.kubernetes.io/name: nextcloud-collabora
    rawResources:
      autoscaling:
        enabled: false
        apiVersion: autoscaling/v2
        kind: HorizontalPodAutoscaler
        spec:
          spec:
            scaleTargetRef:
              apiVersion: apps/v1
              kind: Deployment
              name: nextcloud-collabora
            minReplicas: 1
            maxReplicas: 4
            metrics:
              - type: Resource
                resource:
                  name: cpu
                  target:
                    type: Utilization
                    averageUtilization: 60
              - type: Resource
                resource:
                  name: memory
                  target:
                    type: Utilization
                    averageUtilization: 80
            behavior:
              scaleDown:
                stabilizationWindowSeconds: 300
                policies:
                  - type: Pods
                    value: 1
                    periodSeconds: 60
              scaleUp:
                stabilizationWindowSeconds: 0
                policies:
                  - type: Pods
                    value: 1
                    periodSeconds: 30
```