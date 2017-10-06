FROM alpine:3.6

# SRC_NAME : source directory name
ENV SRC_NAME=""

RUN apk --no-cache add apache2 perl
RUN apk add global --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

RUN mkdir -p /var/www/localhost/htdocs/global
RUN mkdir -p /run/apache2

COPY httpd.conf /etc/apache2/httpd.conf
COPY ./${SRC_NAME} /var/www/localhost/htdocs/global/${SRC_NAME}

WORKDIR /etc/apache2/
RUN sed -i 's/SRC_NAME/${SRC_NAME}/' httpd.conf

WORKDIR /var/www/localhost/htdocs/global/${SRC_NAME}

RUN gtags -v && \
htags -aosnfvF

RUN sed -i 's/\/opt\/local\/bin\/perl/\/usr\/bin\/perl/' HTML/cgi-bin/global.cgi
RUN sed -i 's/\/usr\/local\/bin\/global/\/usr\/bin\/global/' HTML/cgi-bin/global.cgi

CMD /usr/sbin/httpd -D FOREGROUND -f /etc/apache2/httpd.conf
