# Templates

Os templates são um dos recursos mais interessantes do Openshift, pois facilitam o provisionamento de objetos pré-definidos. Podendo ser pods, deployments, serviços, rotas ou todos eles juntos.
Dentro de cada template existem vários outros objetos definidos. Isso pode ser facilmente notado pelas várias chaves **kind** que se repetem.

Mais fácil do que criar um template do zero, é escolher um que se pareça com aquilo que quer e então modificá-lo. Vamos utilizar o template **httpd-example** do catálogo para criar um template para o **lighttpd**:

```
oc get templates -n openshift
oc get templates -n openshift httpd-example -o yaml > lighttpd.yml
```

Faça as modificações que achar pertinente e então adicione o novo template no cluster:

```
oc apply -f lighttpd.yml
```

Os ícones utilizados podem ser do próprio **Openshift**:

[https://rawgit.com/openshift/openshift-logos-icon/master/demo.html](https://rawgit.com/openshift/openshift-logos-icon/master/demo.html)

Ou do **font awesome** versão 4:

[https://fontawesome.com/v4.7.0/icons/](https://fontawesome.com/v4.7.0/icons/)
