FROM bydavy/ubuntu-supervisor
MAINTAINER Davy Leggieri <bydavy@gmail.com>

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Hack for initctl not being available in Ubuntu
#RUN dpkg-divert --local --rename --add /sbin/initctl
#RUN ln -s /bin/true /sbin/initctl

RUN apt-get update -q
RUN apt-get install -qy adduser mongodb-10gen

ENV MONGODB_CONF /root/config/mongodb.conf
RUN mkdir -p /data/db
VOLUME /data/db
EXPOSE 27017

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
