FROM ghost:{{tag}}
MAINTAINER Richard Chien <rchien@gmail.com>

# Install openssh for web-ssh access from kudu
RUN apt-get update && apt-get install \
      --no-install-recommends --no-install-suggests -y \
      openssh-server \
	supervisor \
      git \
      && echo "root:Docker!" | chpasswd

# Creating folder so that image won't fail in non-azure
RUN mkdir -p /home/LogFiles

# workaround for issue with Azure database for MySQL. will be removed later
RUN cd current \
  && npm install mysqljs/mysql \
  && cd /var/lib/ghost

COPY sshd_config /etc/ssh/
COPY init-container.sh /bin/
COPY migrate_util.sh /bin/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf	

EXPOSE 2222
CMD ["/bin/init-container.sh"]