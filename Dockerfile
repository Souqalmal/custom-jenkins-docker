FROM jenkins/jenkins:lts

LABEL author.name="Carlos Garcia-Berro Molero" \
      author.username="gbmcarlos" \
      author.email="gbmcarlos@souqalmal.com"

# If we want to install via apt
# Also to avoid the permission issue of /var/jenkins_home/copy_reference_file.log
USER root

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
