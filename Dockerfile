# Using a compact OS
FROM alpine:latest

MAINTAINER Golfen Guo <golfen.guo@daocloud.io> 

RUN apk --update add nginx

COPY . /usr/share/nginx/html

EXPOSE 80

# Start Nginx and keep it from running background
CMD ["nginx", "-g", "daemon off;"]
