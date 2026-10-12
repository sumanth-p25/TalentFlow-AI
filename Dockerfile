
FROM nginxinc/nginx-unprivileged:alpine

COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/
COPY 1.png /usr/share/nginx/html/

EXPOSE 8080

USER 101
