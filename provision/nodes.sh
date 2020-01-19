#!/bin/bash

yum install -y device-mapper-persistent-data lvm2 docker-1.13.1

systemctl start docker
systemctl enable docker
