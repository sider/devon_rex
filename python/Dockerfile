# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM debian:buster-20200224

ENV GLOBAL_RUBY_VERSION 2.6.5
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


# Install pyenv
USER $RUNNER_USER
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
ARG PYENV_SHIMS_BIN="$RUNNER_USER_HOME/.pyenv/shims"
ARG PYENV_BIN="$RUNNER_USER_HOME/.pyenv/bin"
ENV PATH $PYENV_SHIMS_BIN:$PYENV_BIN:$PATH
ENV PYTHON2_VERSION 2.7.16
ENV PYTHON3_VERSION 3.7.4

# Install Python 2/3 as well as Pipenv for each runtime
RUN pyenv install ${PYTHON2_VERSION} && \
    pyenv install ${PYTHON3_VERSION} && \
    pyenv rehash && \
    for version in $(pyenv versions --bare); do \
      pyenv global ${version} && pip install pipenv; \
    done && \
    pyenv global ${PYTHON3_VERSION}

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD pyenv versions
