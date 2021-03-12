FROM jenkins:2.60.3

USER root

RUN apt-get update \
    && apt-get upgrade -y \
    && mkdir -p ~/.ssh/

RUN apt-get install ssh -y \
    && service ssh start 

EXPOSE 22 

USER jenkins