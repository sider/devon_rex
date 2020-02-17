# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM node:12.16.0-buster

ENV GLOBAL_RUBY_VERSION 2.6.5
ENV BUNDLER1_VERSION 1.17.3
ENV BUNDLER2_VERSION 2.1.4
ENV DEVON_REX_RBENV_VERSION v1.1.2
ENV DEVON_REX_RUBY_BUILD_VERSION v20200115
ENV LANG en_US.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV RUNNER_USER analyzer_runner
ENV RUNNER_USER_HOME /home/$RUNNER_USER
ENV DEBIAN_FRONTEND=noninteractive

COPY base/bin/* /tmp/devon_rex_work/
RUN /tmp/devon_rex_work/prepare


ENV DEVON_REX_NPM_VERSION 6.13.7
RUN npm install --global "npm@${DEVON_REX_NPM_VERSION}"

USER $RUNNER_USER
RUN /tmp/devon_rex_work/build-ruby
ENV PATH ${RUNNER_USER_HOME}/.rbenv/shims:${RUNNER_USER_HOME}/.rbenv/bin:${PATH}

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD node -v && npm -v && yarn -v
