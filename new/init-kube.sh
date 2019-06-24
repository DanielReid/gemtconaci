# kubectl create -f k8s/namespace.yaml

# kubectl create secret tls wildcard-secret \
#   -n addis-poc-devtest \
#   --cert secrets/tls.crt \
#   --key secrets/tls.key 


# kubectl create configmap certificates \
#   -n addis-poc-devtest \
#   --from-file=secrets/ssl/client-crt.pem \
#   --from-file=secrets/ssl/client-key.pem \
#   --from-file=secrets/ssl/ca-crt.pem \
#   --from-file=secrets/ssl/patavi-server-crt.pem \
#   --from-file=secrets/ssl/patavi-server-key.pem

kubectl create secret generic db-credentials -n addis-poc-devtest --from-literal=POSTGRES_PASSWORD=develop --from-literal=PATAVI_DB_PASSWORD=develop --from-literal=GEMTC_DB_PASSWORD=develop
kubectl create configmap gemtc-settings -n addis-poc-devtest --from-literal=DB_HOST=postgres --from-literal=GEMTC_AUTHENTICATION_METHOD=LOCAL --from-literal=GEMTC_COOKIE_SECRET=roakquelRacWyghatpetPionphEncken --from-literal=GEMTC_DB=gemtc --from-literal=GEMTC_DB_USERNAME=gemtc --from-literal=GEMTC_HOST=http://addispoc.corpnet1.com:3001 --from-literal=PATAVI_HOST=addispatavi.corpnet1.com --from-literal=PATAVI_CLIENT_CRT=ssl/crt.pem --from-literal=PATAVI_CLIENT_KEY=ssl/key.pem --from-literal=PATAVI_CA=ssl/ca-crt.pem 
kubectl create secret generic passwords -n addis-poc-devtest --from-literal=rabbit-password=develop
kubectl create configmap patavi-settings -n addis-poc-devtest --from-literal=PATAVI_DB_HOST=postgres-postgresql --from-literal=PATAVI_DB_NAME=patavi --from-literal=PATAVI_DB_USER=patavi --from-literal=PATAVI_PORT=3000 --from-literal=PATAVI_BROKER_HOST=guest:develop@rabbitmq --from-literal=PATAVI_BROKER_USER=guest --from-literal=PATAVI_BROKER_PASSWORD=develop --from-literal=PATAVI_SELF=//addispatavi.corpnet1.com:3000   
kubectl create secret docker-registry registry-credentials -n addis-poc-devtest --docker-server=registry.drugis.org --docker-username=gsk-deploy --docker-password=miekoorthubcirItHakjudJekcopvebr --docker-email=info@drugis.org

kubectl apply -f k8s/postgres.yaml
kubectl apply -f k8s/rabbitmq.yaml
kubectl apply -f k8s/patavi-server.yaml
kubectl apply -f k8s/gemtc.yaml
kubectl apply -f k8s/patavi-smaa-worker.yaml
kubectl apply -f k8s/patavi-gemtc-worker.yaml
kubectl apply -f k8s/gemtc-db-init.yaml
kubectl apply -f k8s/patavi-db-init.yaml

# #ingress/routing
# #mandatory
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
# #service
# #change this if deploying on specific cloud (AWS, GKE, Azure have different versions, see https://kubernetes.github.io/ingress-nginx/deploy/)
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
# kubectl apply -f k8s/ingress.yaml
