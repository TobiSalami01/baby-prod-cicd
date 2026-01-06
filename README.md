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


## Canary Flow Explained

This project uses **Argo Rollouts** to perform a controlled canary deployment instead of replacing all pods at once.

The rollout flow was:

1. **Stable version (v1)** was serving 100% of traffic.
2. A new version (**v3**) was introduced as a **canary**.
3. Traffic was gradually shifted using weights:
   - 10% → pause
   - 25% → pause
   - 50% → pause
   - 100% → promote
4. At each pause, the application was validated using:
   - `/health` endpoint
   - Service DNS (`http://babyapp`)
   - Ingress (`babyapp-prod.local`)
5. Once confirmed healthy, the canary was **promoted to stable**.

This approach reduces risk by exposing only a small portion of users to new changes before full rollout.

---

## How Rollback Would Work

If the canary version showed problems (for example: failed health checks, crashes, or bad responses):

- Argo Rollouts would **stop progressing automatically**
- Traffic would remain on the **last healthy stable version**
- The rollout could be rolled back instantly using:

```bash
kubectl argo rollouts abort babyapp -n prod

