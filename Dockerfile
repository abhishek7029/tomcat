FROM nginx

# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils

# establish where Nginx should look for files
ENV RAILS_ROOT /usr/src/app

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# create log directory
RUN mkdir log

# copy over static assets
COPY public public/

# Copy Nginx config template
COPY docker/web/nginx.conf /tmp/docker.nginx

COPY docker/web/docker-entrypoint.sh /docker-entrypoint.sh

# substitute variable references in the Nginx config template for real values from the environment
# put the final config in its place
#RUN envsubst '$RAILS_ROOT $WEB_PORT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf

EXPOSE $WEB_PORT

ENTRYPOINT ["/docker-entrypoint.sh"]


# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
