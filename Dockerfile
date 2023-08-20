FROM ubuntu:latest
Maintainer Yudin Anton

ENV NGINX_PORT=80


RUN apt-get update && \
    apt-get install -y nginx && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    rm -f /usr/share/nginx/html/index.html
    
#COPY index.html /var/www/html/

EXPOSE $NGINX_PORT

CMD ["nginx"]
