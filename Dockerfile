FROM nginx:alpine

MAINTAINER James Loosli <loosli@gmail.com>

RUN apk update && apk add curl

COPY public/ /usr/share/nginx/html/
