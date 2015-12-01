FROM andrewosh/binder-base

MAINTAINER Matthew Conlen <mc@mathisonian.com>

USER root

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --force-yes \
        libgdal-dev libatlas-base-dev gfortran libfreetype6-dev

RUN pip install git+https://github.com/mathisonian/landsat-util.git@master
RUN pip install geopy colormath

# Spark/Java setup
USER root
RUN apt-get update -y &&\
    apt-get install -y default-jre wget &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*tmp
USER main
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-hadoop1.tgz &&\
    tar -xzf spark-1.4.1-bin-hadoop1.tgz &&\
    rm spark-1.4.1-bin-hadoop1.tgz
ENV SPARK_HOME $HOME/spark-1.4.1-bin-hadoop1
ENV PATH $PATH:$SPARK_HOME/bin
ENV PATH $PATH:$SPARK_HOME/sbin
ENV PYTHONPATH $PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/build:$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip
ENV _JAVA_OPTIONS "-Xms512m -Xmx2g"
