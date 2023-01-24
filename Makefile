.PHONY: build_image dashboard down pause provision start

apply_spark_workload:
	kustomize build platform/workloads/spark-master-standalone | kubectl apply -f -
	kustomize build platform/workloads/spark-worker-standalone | kubectl apply -f -

build_image:
	eval $(minikube docker-env)
	docker build -f images/Dockerfile -t spark-hadoop:3.2.0 .

start:
	minikube start --driver=docker --kubernetes-version=v1.24.6 --cpus='4' --memory='6000' --addons=ingress,dashboard

dashboard:
	minikube dashboard

destroy:
	minikube delete

pause:
	minikube stop

provision: start build_image apply_spark_workload
	