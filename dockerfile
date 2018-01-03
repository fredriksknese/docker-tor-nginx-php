FROM alpine
ENV TORHOME /var/lib/tor
WORKDIR /app

RUN		apk add --no-cache nginx
RUN		apk add --no-cache tor
RUN		apk add --no-cache php7-fpm
RUN		apk add --no-cache parallel
RUN		apk add --no-cache sudo

RUN		echo "" > /etc/tor/torrc
RUN		echo "" > /tmp/hiddenservices.conf
COPY	/src/hiddenservicestemplate.conf /var/hs.tmpl

COPY	/src/nginx.conf /etc/nginx/nginx.conf

COPY	/src/watchauto /bin/watchauto
RUN		chmod +x /bin/watchauto

COPY	/src/entry /bin/entry
RUN		chmod +x /bin/entry

VOLUME  ["/var/hs/"]

ENTRYPOINT	["/bin/entry"]
#ENTRYPOINT	["/bin/ash"]

EXPOSE 80/tcp