#!/bin/sh
# 셸 스크립트 시작 선언

echo "\n📦 Initializing Kubernetes cluster...\n"
# Minikube 클러스터 초기화 메시지 출력

minikube start --cpus 2 --memory 4g --driver docker --profile polar
# Minikube 클러스터 시작: CPU 2개, 메모리 4GB, Docker 드라이버 사용, 프로파일 이름은 'polar'

echo "\n🔌 Enabling NGINX Ingress Controller...\n"
# Ingress Controller 활성화 메시지 출력

minikube addons enable ingress --profile polar
# NGINX Ingress Controller를 Minikube에 추가 (HTTP 라우팅을 위한 필수 구성 요소)

sleep 30
# Ingress Controller가 완전히 활성화될 때까지 대기

echo "\n📦 Deploying Keycloak..."
# Keycloak 배포 시작 메시지 출력

kubectl apply -f services/keycloak-config.yml
kubectl apply -f services/keycloak.yml
# Keycloak 관련 설정(ConfigMap 등)과 배포 리소스를 Kubernetes에 적용

sleep 5
# 리소스가 생성될 시간을 잠시 대기

echo "\n⌛ Waiting for Keycloak to be deployed..."
# Keycloak Pod가 생성되었는지 확인하는 메시지 출력

while [ $(kubectl get pod -l app=polar-keycloak | wc -l) -eq 0 ] ; do
  sleep 5
done
# Keycloak Pod가 생성될 때까지 5초 간격으로 반복 확인

echo "\n⌛ Waiting for Keycloak to be ready..."
# Keycloak Pod가 Ready 상태가 될 때까지 대기

kubectl wait \
  --for=condition=ready pod \
  --selector=app=polar-keycloak \
  --timeout=300s
# Ready 상태가 될 때까지 최대 300초(5분) 대기

echo "\n⌛ Ensuring Keycloak Ingress is created..."
# Keycloak Ingress가 생성되었는지 다시 적용 (중복 적용은 무해함)

kubectl apply -f services/keycloak.yml
# Ingress 리소스가 포함된 경우 재적용하여 보장

echo "\n📦 Deploying PostgreSQL..."
# PostgreSQL 배포 시작 메시지 출력

kubectl apply -f services/postgresql.yml
# PostgreSQL 배포 리소스를 Kubernetes에 적용

sleep 5
# 리소스가 생성될 시간을 잠시 대기

echo "\n⌛ Waiting for PostgreSQL to be deployed..."
# PostgreSQL Pod가 생성되었는지 확인

while [ $(kubectl get pod -l db=polar-postgres | wc -l) -eq 0 ] ; do
  sleep 5
done
# PostgreSQL Pod가 생성될 때까지 반복 확인

echo "\n⌛ Waiting for PostgreSQL to be ready..."
# PostgreSQL Pod가 Ready 상태가 될 때까지 대기

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-postgres \
  --timeout=180s
# Ready 상태가 될 때까지 최대 180초 대기

echo "\n📦 Deploying Redis..."
# Redis 배포 시작 메시지 출력

kubectl apply -f services/redis.yml
# Redis 배포 리소스를 Kubernetes에 적용

sleep 5
# 리소스가 생성될 시간을 잠시 대기

echo "\n⌛ Waiting for Redis to be deployed..."
# Redis Pod가 생성되었는지 확인

while [ $(kubectl get pod -l db=polar-redis | wc -l) -eq 0 ] ; do
  sleep 5
done
# Redis Pod가 생성될 때까지 반복 확인

echo "\n⌛ Waiting for Redis to be ready..."
# Redis Pod가 Ready 상태가 될 때까지 대기

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-redis \
  --timeout=180s
# Ready 상태가 될 때까지 최대 180초 대기

echo "\n📦 Deploying RabbitMQ..."
# RabbitMQ 배포 시작 메시지 출력

kubectl apply -f services/rabbitmq.yml
# RabbitMQ 배포 리소스를 Kubernetes에 적용

sleep 5
# 리소스가 생성될 시간을 잠시 대기

echo "\n⌛ Waiting for RabbitMQ to be deployed..."
# RabbitMQ Pod가 생성되었는지 확인

while [ $(kubectl get pod -l db=polar-rabbitmq | wc -l) -eq 0 ] ; do
  sleep 5
done
# RabbitMQ Pod가 생성될 때까지 반복 확인

echo "\n⌛ Waiting for RabbitMQ to be ready..."
# RabbitMQ Pod가 Ready 상태가 될 때까지 대기

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-rabbitmq \
  --timeout=180s
# Ready 상태가 될 때까지 최대 180초 대기

echo "\n📦 Deploying polar UI..."
# 프론트엔드 UI 배포 시작 메시지 출력

kubectl apply -f services/polar-ui.yml
# UI 배포 리소스를 Kubernetes에 적용

sleep 5
# 리소스가 생성될 시간을 잠시 대기

echo "\n⌛ Waiting for polar UI to be deployed..."
# UI Pod가 생성되었는지 확인

while [ $(kubectl get pod -l app=polar-ui | wc -l) -eq 0 ] ; do
  sleep 5
done
# UI Pod가 생성될 때까지 반복 확인

echo "\n⌛ Waiting for polar UI to be ready..."
# UI Pod가 Ready 상태가 될 때까지 대기

kubectl wait \
  --for=condition=ready pod \
  --selector=app=polar-ui \
  --timeout=180s
# Ready 상태가 될 때까지 최대 180초 대기

echo "\n⛵ Happy Sailing!\n"
# 모든 서비스가 배포 완료되었음을 알리는 메시지 출력