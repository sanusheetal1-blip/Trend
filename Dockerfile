FROM nginx:alpine

# Clear default Nginx web files
RUN rm -rf /usr/share/nginx/html/*

# Copy your repository static files directly to Nginx web root
COPY . /usr/share/nginx/html

# Change default Nginx port from 80 to 3000
RUN sed -i 's/listen     80;/listen     3000;/g' /etc/nginx/conf.d/default.conf

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
