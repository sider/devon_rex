# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM node:12.16.1-buster

ENV GLOBAL_RUBY_VERSION 2.7.0
ENV BUNDLER1_VERSION 1.17.3
ENV BUNDLER2_VERSION 2.1.4
ENV DEVON_REX_RUBY_BUILD_VERSION 20200224
ENV LANG en_US.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV RUNNER_USER analyzer_runner
ENV RUNNER_USER_HOME /home/$RUNNER_USER
ENV DEBIAN_FRONTEND noninteractive

COPY base/bin/* /tmp/devon_rex_work/
RUN /tmp/devon_rex_work/prepare

COPY base/etc/* /usr/local/etc/


RUN /tmp/devon_rex_work/build-ruby

COPY npm/package.json /tmp/
RUN npm_version=$(node -pe 'require("/tmp/package.json").dependencies.npm') && \
    npm install --global "npm@${npm_version}" && \
    rm /tmp/package.json

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD node -v && npm -v && yarn -v
