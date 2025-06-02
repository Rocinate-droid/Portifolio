FROM ubuntu
WORKDIR /app
RUN apt update
RUN apt install nginx -y
COPY index.html /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
