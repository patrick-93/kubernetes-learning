FROM registry.access.redhat.com/ubi8:latest
env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin
RUN dnf -y upgrade && dnf install -y java-11-openjdk
EXPOSE 8080
ENTRYPOINT /bin/bash

