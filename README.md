# Database
Este Kubernetes más Rancher para implementar un Pipeline básico de base de datos

### Pre-requisitos 📋
1. Conocimientos en Docker
2. Servidor rancher en cualquier plataforma. (LOCAL o NUBE)
3. Tiempo

### Instalación 🔧
1. Crear Archivo .rancher-pipeline.yml 
```
nano .rancher-pipeline.yml
```
```
stages:
- name: Crear Imagen
  steps:
  - publishImageConfig:
      dockerfilePath: ./Dockerfile
      buildContext: .
      tag: andreeavalos/pipeline-database
      pushRemote: true
      registry: index.docker.io
- name: Crear en k8s
  steps:
  - applyYamlConfig:
      path: ./deployment.yaml
timeout: 60
notification: {}

```
2. Crear Archivo deployment.yaml
```
nano deployment.yaml
```
```
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: database
  namespace: entrega-final
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      workload.user.cattle.io/workloadselector: deployment-entrega-final-database
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      labels:
        workload.user.cattle.io/workloadselector: deployment-entrega-final-database
    spec:
      containers:
      - image: mysql:latest
        imagePullPolicy: Always
        name: database
        env:
          # Use secret in real usage
        - name: MYSQL_ROOT_PASSWORD
          value: "1234"
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage

      dnsPolicy: ClusterFirst
      imagePullSecrets:
      - name: dockerhub
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
---      
apiVersion: v1
kind: Service
metadata:
  annotations:
    field.cattle.io/targetWorkloadIds: '["deployment:entrega-final:database"]'
    workload.cattle.io/targetWorkloadIdNoop: "true"
    workload.cattle.io/workloadPortBased: "true"
  labels:
    cattle.io/creator: norman
  name: mysql-loadbalancer
  namespace: entrega-final
spec:
  externalTrafficPolicy: Cluster
  ports:
  - port: 3306
    protocol: TCP
    targetPort: 3306
  selector:
    workload.user.cattle.io/workloadselector: deployment-entrega-final-database
  type: LoadBalancer
```
3. Crear Dockerfile
```
FROM mysql:latest

ADD . /database
# Add a database
ENV MYSQL_DATABASE bd_p1

# Add the content of the sql-scripts/ directory to your image
# All scripts in docker-entrypoint-initdb.d/ are automatically
# executed during container startup
COPY ./sql-scripts/ /docker-entrypoint-initdb.d/
```
4. Cada vez que se hace un commit, rancher lo toma automaticamente

* [Sergio Mendez](https://www.youtube.com/watch?v=k4y776PqTwI)-Guia de instalacion de rancher