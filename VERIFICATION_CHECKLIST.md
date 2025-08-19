# ✅ Verification Checklist - Milestone 2 Project

## 🎯 **Complete System Verification**

Use this checklist to verify that your entire system is working correctly before presenting to your teacher.

---

## 📋 **1. Kubernetes Cluster Status**

### ✅ **Check Pods are Running**
```powershell
kubectl get pods -n lm-webstack
```
**Expected Output:**
```
NAME                           READY   STATUS    RESTARTS   AGE
api-lm-7fddd97999-6xng9        1/1     Running   0          2m
frontend-lm-5b9455fcdc-pfwc2   1/1     Running   0          46m
postgres-lm-6fc9b97d9c-8nlsh   1/1     Running   0          46m
```

### ✅ **Check Services are Available**
```powershell
kubectl get services -n lm-webstack
```
**Expected Output:**
```
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
api-lm        ClusterIP   10.96.210.238   <none>        8000/TCP       53m
frontend-lm   NodePort    10.96.37.251    <none>        80:30000/TCP   53m
postgres-lm   ClusterIP   10.96.208.235   <none>        5432/TCP       53m
```

### ✅ **Check ConfigMaps and Secrets**
```powershell
kubectl get configmaps -n lm-webstack
kubectl get secrets -n lm-webstack
kubectl get pvc -n lm-webstack
```

---

## 🔧 **2. API Endpoints Testing**

### ✅ **Test API Health Check**
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/health" -Method GET
```
**Expected Output:** `{"status": "healthy"}`

### ✅ **Test Get Current User**
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method GET
```
**Expected Output:** `{"name": "Fixed User"}` (or whatever name you set)

### ✅ **Test Update User Name**
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method POST -Headers @{ "Content-Type" = "application/json" } -Body '{"name":"Your Name"}'
```
**Expected Output:** `{"message":"User name updated successfully","name":"Your Name"}`

### ✅ **Verify Name Update Persisted**
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method GET
```
**Expected Output:** `{"name":"Your Name"}` (should match what you set)

### ✅ **Test Container ID Endpoint**
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/container-id" -Method GET
```
**Expected Output:** `{"container_id":"api-lm-xxxxx"}`

---

## 🌐 **3. Frontend Testing**

### ✅ **Access Frontend Website**
1. Open browser to: `http://localhost:8080`
2. **Expected:** You should see a webpage with "**[Your Name]** has reached milestone 2!"

### ✅ **Test Name Update Flow**
1. Update name via API (see step 2.3 above)
2. Refresh the browser page
3. **Expected:** The webpage should show the new name

---

## 🔄 **4. Port Forwarding Setup**

### ✅ **API Port Forward**
```powershell
kubectl port-forward -n lm-webstack svc/api-lm 8000:8000
```
**Status:** Should show "Forwarding from 127.0.0.1:8000 -> 8000"

### ✅ **Frontend Port Forward**
```powershell
kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80
```
**Status:** Should show "Forwarding from 127.0.0.1:8080 -> 80"

---

## 🐳 **5. Docker Images**

### ✅ **Check Images are Built**
```powershell
docker images | findstr "lm"
```
**Expected Output:**
```
api-lm        latest    xxxxxxxx    xxxx    xxx MB
frontend-lm   latest    xxxxxxxx    xxxx    xxx MB
postgres-lm   latest    xxxxxxxx    xxxx    xxx MB
```

### ✅ **Check Images are Loaded in Kind**
```powershell
& "$env:USERPROFILE\tools\kind.exe" load docker-image api-lm:latest --name milestone2
& "$env:USERPROFILE\tools\kind.exe" load docker-image frontend-lm:latest --name milestone2
& "$env:USERPROFILE\tools\kind.exe" load docker-image postgres-lm:latest --name milestone2
```

---

## 📊 **6. Database Verification**

### ✅ **Check Database Logs**
```powershell
kubectl logs postgres-lm-6fc9b97d9c-8nlsh -n lm-webstack --tail=10
```
**Expected:** Should show database is running and accepting connections

### ✅ **Check API Logs**
```powershell
kubectl logs api-lm-7fddd97999-6xng9 -n lm-webstack --tail=10
```
**Expected:** Should show API requests being processed

---

## 🎯 **7. Complete Demo Flow**

### ✅ **Full End-to-End Test**
1. **Start everything:** `powershell -ExecutionPolicy Bypass -File run.ps1 all`
2. **Set up port forwarding** (see step 4)
3. **Access frontend:** Open `http://localhost:8080`
4. **Update name:** Use API to change the name
5. **Verify change:** Refresh frontend to see new name
6. **Show Kubernetes status:** `kubectl get pods -n lm-webstack`

---

## 🚨 **8. Troubleshooting**

### ❌ **If Pods are not Running:**
```powershell
kubectl describe pod <pod-name> -n lm-webstack
kubectl logs <pod-name> -n lm-webstack
```

### ❌ **If API is not responding:**
1. Check if port-forward is running
2. Restart port-forward: `kubectl port-forward -n lm-webstack svc/api-lm 8000:8000`
3. Check API logs: `kubectl logs api-lm-xxxxx -n lm-webstack`

### ❌ **If Frontend is not accessible:**
1. Check if port-forward is running
2. Restart port-forward: `kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80`
3. Check frontend logs: `kubectl logs frontend-lm-xxxxx -n lm-webstack`

### ❌ **If name updates don't persist:**
1. Check database logs
2. Verify PVC is bound: `kubectl get pvc -n lm-webstack`
3. Restart API pod: `kubectl rollout restart deployment/api-lm -n lm-webstack`

---

## 🎉 **9. Success Criteria**

### ✅ **All Systems Operational**
- [ ] All 3 pods are running (frontend, api, postgres)
- [ ] All services are available
- [ ] API endpoints respond correctly
- [ ] Frontend displays correctly
- [ ] Name updates work and persist
- [ ] Database data is persistent
- [ ] Port forwarding works for both services

### ✅ **Ready for Demo**
- [ ] Can show the architecture diagram
- [ ] Can demonstrate the complete flow
- [ ] Can explain each component
- [ ] Can show Kubernetes status
- [ ] Can answer questions about the technology stack

---

## 📝 **10. Quick Commands Reference**

```powershell
# Check status
kubectl get pods -n lm-webstack
kubectl get services -n lm-webstack

# Access services
kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80
kubectl port-forward -n lm-webstack svc/api-lm 8000:8000

# Test API
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method GET
Invoke-WebRequest -Uri "http://localhost:8000/user" -Method POST -Headers @{ "Content-Type" = "application/json" } -Body '{"name":"Test Name"}'

# View logs
kubectl logs api-lm-xxxxx -n lm-webstack
kubectl logs postgres-lm-xxxxx -n lm-webstack

# Restart if needed
kubectl rollout restart deployment/api-lm -n lm-webstack
```

---

## 🎯 **Final Verification**

**Your system is ready when:**
1. ✅ All checkboxes above are completed
2. ✅ You can demonstrate the complete name update flow
3. ✅ You can explain how each component works
4. ✅ You can show the Kubernetes resources
5. ✅ Everything works reliably

**Congratulations! Your Milestone 2 project is fully operational! 🚀** 