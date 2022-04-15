FROM ubuntu:20.04
LABEL author="Venkat S. Malladi"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y --fix-missing && \
  apt-get upgrade -y && \
  apt-get dist-upgrade -y && \
  apt-get autoremove -y && \
  apt-get update -y --fix-missing && \
  apt-get upgrade -y

RUN apt-get install -y wget
RUN  wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux && tar -xf azcopy_v10.tar.gz --strip-components=1
RUN cp ./azcopy /usr/local/bin/


ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get install -y python3 python3-pip


RUN pip3 install croo==0.6.0
