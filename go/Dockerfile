# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM golang:1.14.0-buster

ENV GLOBAL_RUBY_VERSION 2.7.0
ENV BUNDLER1_VERSION 1.17.3
ENV BUNDLER2_VERSION 2.1.4
ENV LANG en_US.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV RUNNER_USER analyzer_runner
ENV RUNNER_GROUP nogroup
ENV RUNNER_USER_HOME /home/${RUNNER_USER}
ENV RUNNER_RUBY_HOME ${RUNNER_USER_HOME}/ruby
ENV PATH ${RUNNER_RUBY_HOME}/bin:${PATH}
ENV DEBIAN_FRONTEND noninteractive

COPY base/bin/prepare /tmp/devon_rex_work/
RUN /tmp/devon_rex_work/prepare

USER $RUNNER_USER

COPY base/bin/build-ruby /tmp/devon_rex_work/
RUN RUBY_BUILD_VERSION="20200224" /tmp/devon_rex_work/build-ruby
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} base/etc/gemrc ${RUNNER_RUBY_HOME}/etc/
RUN gem environment


# Install Glide
# See https://github.com/Masterminds/glide
RUN curl https://glide.sh/get | sh

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD go version
