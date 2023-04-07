FROM nginx:latest
RUN rm -rf /usr/share/nginx/html/*
RUN mkdir -p /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/
COPY ./images/red.png /usr/share/nginx/html/images/
COPY ./images/blue.jpg /usr/share/nginx/html/images/
