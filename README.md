# gemtconaci
Gemtc on Azure and AKS

## Deploy

1. Open the Azure Cloud Shell
2. Clone the repo
3. Edit the file Kubernetes/patavi-server.yaml, and ammend the PATAVI_SELF environment variable to be the name of the Patavi instance, this would need a DNS name mapped to the service IP address, as well as an SSL cert for this host as the trust mechanism.  It is this SSL keychain that is needed in the ssl/ directory for the following....

Place the CA Cert (ca-crt.pem), Key (key.pem) and Certificate (crt.pem) in the ssl/ directory, and create the configmap for the GeMTC and Patavi components:

```bash
cd ssl/
kubectl create configmap  certs --from-file=key.pem --from-file=crt.pem --from-file=ca-crt.pem
```

I would advise to create the Services first:

```
kubectl apply -f Kubernetes/gemtc_svc.yaml
kubectl apply -f Kubernetes/patavi-server_svc.yaml
```

Then move onto the backing services (which will be in-cluster):

```
kubectl apply -f Kubernetes/postgres.yaml
kubectl apply -f Kubernetes/rabbitmq.yaml
```

Wait fro between 5/10 minutes until the services are in READY state with 

```
kubectl get pods
```

Then deploy the ADDIS stack:

```
kubectl apply -f Kubernetes/gemtc.yaml
kubectl apply -f Kubernetes/patavi-gemtc-worker.yaml
kubectl apply -f Kubernetes/patavi-server.yaml
```

Wait for a few minutes, check everything is in READY state, then get the **gemtc** service IP address:

```
kubectl get svc
```

