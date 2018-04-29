FROM jenkins/jenkins:lts

LABEL author.name="Carlos Garcia-Berro Molero" \
      author.username="gbmcarlos" \
      author.email="gbmcarlos@souqalmal.com"

# If we want to install via apt
# Also to avoid the permission issue of /var/jenkins_home/copy_reference_file.log
USER root

# Add php repository
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C; \
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list; \
    echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list

# Install php7.1
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get -qy install \
    php7.1 \
    php7.1-mbstring \
    php7.1-xml

# Install sass
RUN apt-get update; \
    apt-get -y install ruby-full build-essential rubygems; \
    gem install sass

# Install composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install plugins
RUN /usr/local/bin/install-plugins.sh \
  github \
  scm-sync-configuration \
  managed-scripts \
  s3 \
  gradle:1.25 \
  multiple-scms \
  ws-cleanup \
  nodejs \
  matrix-auth \
  sbt \
  dashboard-view

# Configure SSH client
RUN echo '\n \
StrictHostKeyChecking no \n \ 
Host * \n \
  IdentityFile /var/jenkins_home/.ssh/ssh_key.pem\n' \
>> /etc/ssh/ssh_config

# SCM Sync Configuration plugin cannot use the default Jenkins credentials utility, so we need to set git credentials locally
COPY ./git/* /root/
