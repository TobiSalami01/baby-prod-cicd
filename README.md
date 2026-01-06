# baby-prod-cicd (Kubernetes + Argo Rollouts + Kustomize)

This project demonstrates a production-style deployment workflow using:
- **Kubernetes (Minikube)**
- **Argo Rollouts (Canary strategy)**
- **Kustomize (base + prod overlay)**
- **Ingress** for friendly hostname routing

## What you accomplished
✅ Canary rollout from **v1 → v3** (controlled, not random patching)  
✅ Promoted to stable after verifying `/health` and service traffic  
✅ Injected `APP_VERSION=v3` via the **prod overlay patch**  
✅ Verified traffic through:
- Ingress (`babyapp-prod.local`)
- Service DNS (`http://babyapp/` inside cluster)
- Direct pod endpoints (Endpoint IPs)

---

## Repo structure
- `app/` → Flask app (returns message + version)
- `k8s/base/` → reusable Kubernetes manifests (Rollout/Service/etc.)
- `k8s/overlays/prod/` → prod-specific patches (image + env + ingress + namespace)

---

## Quick run (Minikube)
### 1) Start cluster
```bash
minikube start

