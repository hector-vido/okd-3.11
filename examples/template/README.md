# Templates

Mais fácil do que criar um template do zero, é escolher um que se pareça com aquilo que quer e então modificá-lo:

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
