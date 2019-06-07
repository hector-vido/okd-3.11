# Registry

Para se logar no registry interno do OKD e conseguir subir novas imagens sem precisar torná-las públicas, primeiro é preciso fazer o login do usuário em questão:


```
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin user
oc login -u user
```

Feito isso, busque pelo serviço chamado **docker-registry**:

```
oc get svc
NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                   AGE
docker-registry    ClusterIP   172.30.136.192   <none>        5000/TCP                  3d
```

E faça login utilizando o comando **docker** e o token do usuário:

```
docker login -u user -p $(oc whoami -t) 172.30.136.192:5000
```

Podemos utilizar o exemplo de s2i gerado nos tutoriais presentes neste repositório, para isso será preciso gerar uma nova tag para a imagem e então enviá-la para o registry:

```
docker tag lighttpd-centos7 172.30.136.192:5000/openshift/lighttpd-centos7
docker push 172.30.136.192:5000/openshift/lighttpd-centos7
oc get images | grep lighttpd-centos7
```

Subindo no namespace **openshift** esta image ficará disponível para todo os projetos. Mas também é possível subir em qualquer outro namespace.

### Certificado auto-assinado

Caso o registry utilize um certificado auto-assinado, você pode adicionar a faixa de IP do OKD dentro da diretiva **insecure-registry** do Docker:

**/etc/sysconfig/docker**
```
# /etc/sysconfig/docker

# Modify these options if you want to change the way the docker daemon runs
OPTIONS=' --selinux-enabled --signature-verification=False --insecure-registry=172.30.0.0/16'
...
```
