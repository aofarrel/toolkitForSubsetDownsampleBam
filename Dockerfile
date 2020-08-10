##########################################################################
# Dockerfile to build a downsampling tool container for BAM files
##########################################################################

# Creates layer from the ubuntu 14.04 docker image
FROM ubuntu:14.04

MAINTAINER Nicholas Vasquez <nivasquez@csumb.edu>

# Setup packages. Run builds application
USER root
RUN apt-get -m update 
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa && apt-get update -q && apt-get install -y openjdk-11-jdk
RUN apt-get install -y wget unzip zip
RUN apt-get install -y wget build-essential

RUN apt-get install -y ncurses-dev zlib1g-dev
RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
RUN mv samtools-1.3.1.tar.bz2 /opt
WORKDIR /opt
RUN tar -jxf samtools-1.3.1.tar.bz2
WORKDIR samtools-1.3.1
RUN ./configure
RUN make
RUN make install

WORKDIR /opt/samtools-1.3.1

# switch back to the ubuntu user so this tool (and the files written) are not owned by root
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 -m ubuntu
USER ubuntu

# by default /bin/bash is executed. cmd specifies what command to run within container
CMD ["/bin/bash"]