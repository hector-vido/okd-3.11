Source to Image - s2i
=====================

Este tutorial é uma leve modificação de [https://blog.openshift.com/create-s2i-builder-image/](https://blog.openshift.com/create-s2i-builder-image/).

O s2i é uma ferramenta muito útil para criar imagens construtoras, muito utilizada no **Openshift 3**.
A principal vantagem é prevenir que os desenvolvedores utilizem comandos de sistema durante a criação da imagem e fornecer um ambiente padrão de boas práticas para suas aplicações.

Baixe o binário **s2i** em [https://github.com/openshift/source-to-image/releases/tag/v1.1.14](https://github.com/openshift/source-to-image/releases/tag/v1.1.14) e instale em sua máquina:

## Primeiro

```
wget https://github.com/openshift/source-to-image/releases/download/v1.1.14/source-to-image-v1.1.14-874754de-linux-amd64.tar.gz
tar -xzf source-to-image-v1.1.14-874754de-linux-amd64.tar.gz
mv s2i /usr/bin/
```
## Segundo

O seguinte comando criará uma pasta chamada **s2i-lighttpd** que ao final criará uma imagem chamada **lighttpd-centos7**:

```
s2i create lighttpd-centos7 s2i-lighttpd
```

O conteúdo do diretório será semelhante ao seguinte:

```
find s2i-lighttpd/

s2i-lighttpd/
s2i-lighttpd/s2i
s2i-lighttpd/s2i/bin
s2i-lighttpd/s2i/bin/assemble
s2i-lighttpd/s2i/bin/run
s2i-lighttpd/s2i/bin/usage
s2i-lighttpd/s2i/bin/save-artifacts
s2i-lighttpd/Dockerfile
s2i-lighttpd/README.md
s2i-lighttpd/test
s2i-lighttpd/test/test-app
s2i-lighttpd/test/test-app/index.html
s2i-lighttpd/test/run
s2i-lighttpd/Makefile
```

## Terceiro

Modifique o Dockerfile para que fique semelhante ao conteúdo a seguir:

**Dockerfile**

```
# lighttpd-centos7
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Hector Vido <hector_vido@yahoo.com.br>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV LIGHTTPD_VERSION=1.4.53

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for serving static HTML files" \
      io.k8s.display-name="Lighttpd 1.4.53" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,lighttpd"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y epel-release && yum install -y lighttpd && yum clean all -y

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/
# Defines the location of the S2I
LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# Copy the lighttpd configuration file
COPY ./etc/ /opt/app-root/etc

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
```

## Quarto

Modifique o arquivo responsável pela construção da aplicação:

**s2i/bin/assemble**
```
#!/bin/bash -e
#
# S2I assemble script for the 'lighttpd-centos7' image.
# The 'assemble' script builds your application source so that it is ready to run.
#
# For more information refer to the documentation:
#       https://github.com/openshift/source-to-image/blob/master/docs/builder_image.md
#

# If the 'lighttpd-centos7' assemble script is executed with the '-h' flag, print the usage.
if [[ "$1" == "-h" ]]; then
        exec /usr/libexec/s2i/usage
fi

echo "---> Installing application source..."
cp -Rf /tmp/src/. ./
```

## Quinto

Modifique o arquivo responsável por iniciar a aplicação:

**s2i/bin/run**
```
#!/bin/bash -e
#
# S2I run script for the 'lighttpd-centos7' image.
# The run script executes the server that runs your application.
#
# For more information see the documentation:
#       https://github.com/openshift/source-to-image/blob/master/docs/builder_image.md
#

exec lighttpd -D -f /opt/app-root/etc/lighttpd.conf
```

## Sexto

Dentro do arquivo *usage* colocaremos informações de como utilizar a imagem:


**s2i/bin/usage**
```
#!/bin/bash -e

cat <<EOF
This is the lighttpd-centos7 S2I image:
To use it, install S2I: https://github.com/openshift/source-to-image

Sample invocation:

s2i build https://github.com/hector-vido/sti-lighttpd.git lighttpd-centos7 lighttpd-ex

You can then run the resulting image via:
docker run -p 8080:8080 lighttpd-ex
EOF
```

## Setimo

Crie uma pasta **etc** e coloque dentro dela o arquivo de configuração do *lighttpd*:

**etc/lighttpd.conf**
```
# directory where the documents will be served from
server.document-root = "/opt/app-root/src"

# port the server listens on
server.port = 8080

# default file if none is provided in the URL
index-file.names = ( "index.html" )

# configure specific mimetypes, otherwise application/octet-stream will be used for every file
mimetype.assign = (
  ".html" => "text/html",
  ".txt" => "text/plain",
  ".jpg" => "image/jpeg",
  ".png" => "image/png"
)
```

## Oitavo

Feito isso, construa a aplicação com o **make**, que internamente está chamando o comando *docker build*:


```
make
```

## Nono

Para ver a execução do script **usage**, basta rodar a imagem:

```
docker run lighttpd-centos7

This is the lighttpd-centos7 S2I image:
To use it, install S2I: https://github.com/openshift/source-to-image

Sample invocation:

s2i build https://github.com/hector-vido/sti-lighttpd.git lighttpd-centos7 lighttpd-ex

You can then run the resulting image via:
docker run -p 8080:8080 lighttpd-ex
```

Como estamos construindo nossa imagem, podemos jogar arquivos HTML dentro do diretório **test/test-app/** e executar o comando *s2i build test/test-app/ lighttpd-centos7 lighttpd-ex*. Mas como o repositório indicado existe, vamos utilizá-lo:

```
s2i build https://github.com/hector-vido/sti-lighttpd.git lighttpd-centos7 lighttpd-ex
docker run -p 8080:8080 lighttpd-ex
```
