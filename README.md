# docker-tor-nginx-php
Dockerfile built on Alpine to run Tor, Ngninx, and PHP

This is a dockerimage that works on Windows.

#Build
docker build . -t myapp
#Start
docker run -v c:\data\:/var/hs -p 80:80 -it myapp

The system will monitor /var/hs for changes in directory structure.
