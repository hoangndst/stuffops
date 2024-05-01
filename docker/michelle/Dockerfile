FROM nginx:1.22.0-alpine

COPY index.html /usr/share/nginx/html
COPY style.css /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

