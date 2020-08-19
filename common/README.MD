# 使用方法

## 初始化k8s、k8s添加节点


```bash
ansible-playbook k8s.yml -e group=k8s-test
ansible-playbook k8s.yml -e group=k8s-dev
ansible-playbook k8s.yml -e group=k8s-stage
ansible-playbook k8s.yml -e group=k8s-dmos
ansible-playbook k8s.yml -e group=k8s-prd
ansible-playbook k8s.yml -e group=....
```



## 服务器初始化

```bash
ansible-playbook init.yml -e group=***
```

## jdk、zk、kafka、mongodb部署
```
ansible-playbook jdk.yml
ansible-playbook zk.yml
ansible-playbook kafka.yml
ansible-playbook mongo.yml
```
