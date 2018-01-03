FROM alpine
ENV TORHOME /var/lib/tor
WORKDIR /app

RUN		apk add --no-cache nginx
RUN		apk add --no-cache tor
RUN		apk add --no-cache php7-fpm
RUN		apk add --no-cache openrc
RUN		apk add --no-cache sudo

RUN		echo '#!/sbin/openrc-run' > /etc/init.d/watchauto
RUN		echo 'command="/bin/watchauto"' >> /etc/init.d/watchauto
RUN		chmod +x /etc/init.d/watchauto

RUN		rc-update add nginx default
RUN		rc-update add tor default
RUN		rc-update add php-fpm7 default
RUN		rc-update add watchauto default

RUN		sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab 
        # Change subsystem type to "docker"
RUN     sed -i 's/#rc_sys=".*"/rc_sys="docker"/g' /etc/rc.conf
        # Allow all variables through 
RUN		sed -i 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' /etc/rc.conf
        # Dont start crashed services?
RUN		sed -i 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' /etc/rc.conf
RUN		sed -i 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' /etc/rc.conf
#RUN		sed -i 's/#rc_logger=.*/rc_logger=YES/g' /etc/rc.conf
        # Define extra dependencies for services
RUN		sed -i 's/#rc_provide=".*"/rc_provide="loopback net"/g' /etc/rc.conf
		# Remove unnecessary services
RUN		rm -f /etc/init.d/hwdrivers
RUN		rm -f /etc/init.d/hwclock
RUN		rm -f /etc/init.d/hwdrivers
RUN		rm -f /etc/init.d/modules
RUN		rm -f /etc/init.d/modules-load
RUN		rm -f /etc/init.d/modloop
RUN		sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh
RUN		sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh

COPY	/src/watchauto /bin/watchauto
RUN		chmod +x /bin/watchauto

COPY	/src/copyhs /bin/copyhs
RUN		chmod +x /bin/copyhs

RUN		echo "" > /etc/tor/torrc
RUN		echo "" > /tmp/hiddenservices.conf
COPY	/src/hiddenservicestemplate.conf /var/hs.tmpl

COPY	/src/nginx.conf /etc/nginx/nginx.conf

VOLUME  ["/var/hs/"]

WORKDIR /etc/init.d

ENTRYPOINT	["/sbin/init"]
#ENTRYPOINT	["/bin/ash"]


EXPOSE 80/tcp