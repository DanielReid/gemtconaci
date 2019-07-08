# gemtconaci
Gemtc Components on AKS

Once and AKS cluster has been instantiated, you will need to create configmaps (configuration inherited via environment variables to your Addis components)

## Create secrets for components

### Default credentials for PostgreSQL

```bash
kubectl create secret generic db-credentials \
  -n gemtc \
  --from-literal=POSTGRES_PASSWORD=develop \
  --from-literal=PATAVI_DB_PASSWORD=develop \
  --from-literal=GEMTC_DB_PASSWORD=develop
```

### Environment variables for Gemtc service
```
kubectl create configmap gemtc-settings \
  -n gemtc \
  --from-literal=DB_HOST=postgres \
  --from-literal=GEMTC_AUTHENTICATION_METHOD=LOCAL \
  --from-literal=GEMTC_COOKIE_SECRET=roakquelRacWyghatpetPionphEncken \
  --from-literal=GEMTC_DB=gemtc \
  --from-literal=GEMTC_DB_USERNAME=gemtc \
  --from-literal=GEMTC_HOST=gemtc:3001 \
  --from-literal=PATAVI_HOST=patavi-server \
  --from-literal=PATAVI_CLIENT_CRT=ssl/crt.pem \
  --from-literal=PATAVI_CLIENT_KEY=ssl/key.pem
#  --from-literal=PATAVI_CA= \
```

**Note:** the SSL certificates will need to be created by **your** organisation to be able to setup a trust relationship to access data from Patavi.

Place the CA Cert (ca-crt.pem), Key (key.pem) and Certificate (crt.pem) in the ssl/ directory, and create the configmap for the GeMTC and Patavi components:

```bash
cd ssl/
kubectl create configmap  certs --from-file=key.pem --from-file=crt.pem --from-file=ca-crt.pem
```


### Default password for RabbitMQ Service
```
kubectl create secret generic passwords \
 -n gemtc \
 --from-literal=rabbit-password=develop
```

### Environment variables for Patavi service
```
kubectl create configmap patavi-settings \
  -n gemtc \
  --from-literal=PATAVI_DB_HOST=postgres-postgresql \
  --from-literal=PATAVI_DB_NAME=patavi \
  --from-literal=PATAVI_DB_USER=patavi \
  --from-literal=PATAVI_PORT=3000 \
  --from-literal=PATAVI_BROKER_HOST=guest:develop@rabbitmq \
  --from-literal=PATAVI_BROKER_USER=guest \
  --from-literal=PATAVI_BROKER_PASSWORD=develop \
  --from-literal=PATAVI_SELF=//PATAVI_HOST:3000   # this needs to be in the yaml
```

**Note**: Replace *PATAVI_HOST* with the FQDN of the published patavi service (e.g. patavi.mydomain.com)

```
kubectl create secret docker-registry registry-credentials \
  -n gemtc \
  --docker-server=registry.drugis.org \
  --docker-username=REGISTRY_USERNAME \
  --docker-password=REGISTRY_PASSWORD \
  --docker-email=info@drugis.org
```

**Note**: replace *REGISTRY_USERNAME* and *REGISTRY_PASSWORD* with those given by drugis.org

## Deploy

1. Open the Azure Cloud Shell
2. Clone the repo
3. Edit the file Kubernetes/patavi-server.yaml, and ammend the PATAVI_SELF environment variable to be the name of the Patavi instance, this would need a DNS name mapped to the service IP address.



I would advise to create the Services first:

```
kubectl apply -f Kubernetes/gemtc_svc.yaml
kubectl apply -f Kubernetes/patavi_svc.yaml
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
kubectl apply -f Kubernetes/patavi-smaa-worker.yaml
kubectl apply -f Kubernetes/patavi-gemtc-worker.yaml
kubectl apply -f Kubernetes/gemtc-db-init.yaml
kubectl apply -f Kubernetes/patavi-db-init.yaml
```

kubectl apply -f k8s/patavi-smaa-worker.yaml
kubectl apply -f k8s/patavi-gemtc-worker.yaml
kubectl apply -f k8s/gemtc-db-init.yaml
kubectl apply -f k8s/patavi-db-init.yaml


Wait for a few minutes, check everything is in READY state, then get the **gemtc** service IP address:

```
kubectl get svc
```


# Creating users
Edit the file [./db/db-init.sql](./db/db-init.sql) and add users through a SQL INSERT statement:

```sql
INSERT INTO Account (username, firstName, lastName, password) VALUES ('USERNAME', 'FIRSTNAME', 'LASTNAME', 'HASH')
```

For the Password Hash, run the script [./pw.sh](./pw.sh) to generate a hash from the password.

## Apply SQL for users
Once the list of users has been created, use the kubectl exec command to apply this to the cluster:

```bash
kubectl exec -it postgres /bin/bash
> psql
```

Copy and past the lines of SQL, and the users will be able to login with their credentials.

