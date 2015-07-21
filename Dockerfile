# First dockerfile
FROM ubuntu:14.04
MAINTAINER hanfeng "contact.hanfeng.name"
RUN apt-get update
RUN apt-get install -y nginx
EXPOSE 80
