# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM debian:buster-20200720 AS git-builder

ARG GIT_VERSION=2.27.0
ARG GIT_SOURCE_TARBALL=git-${GIT_VERSION}.tar.xz
ARG GIT_SOURCE_URL=https://mirrors.edge.kernel.org/pub/software/scm/git/${GIT_SOURCE_TARBALL}
ARG GIT_SOURCE_SHA256_URL=https://mirrors.edge.kernel.org/pub/software/scm/git/sha256sums.asc
ARG DEBIAN_FRONTEND=noninteractive

# See https://git-scm.com/book/en/v2/Getting-Started-Installing-Git#_installing_from_source
RUN apt-get update -y && \
    apt-get install -qq -y --no-install-recommends \
      dh-autoreconf \
      libcurl4-gnutls-dev \
      libexpat1-dev \
      gettext \
      libz-dev \
      libssl-dev \
      curl \
      ca-certificates \
      ;
RUN curl -fsSLO --compressed "${GIT_SOURCE_URL}" && \
    curl -fsSL --compressed "${GIT_SOURCE_SHA256_URL}" | \
      grep "${GIT_SOURCE_TARBALL}" | \
      sha256sum --check --strict && \
    mkdir -p /tmp/git-build && tar -xf "${GIT_SOURCE_TARBALL}" -C /tmp/git-build --strip-components=1
RUN cd /tmp/git-build && \
    make configure && \
    ./configure && \
    make install DESTDIR=/opt/git


FROM debian:buster-20200607

ENV GLOBAL_RUBY_VERSION 2.7.1
ENV BUNDLER1_VERSION 1.17.3
ENV BUNDLER2_VERSION 2.1.4
ENV LANG en_US.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV RUNNER_USER analyzer_runner
ENV RUNNER_GROUP nogroup
ENV RUNNER_USER_HOME /home/${RUNNER_USER}
ENV GEM_HOME ${RUNNER_USER_HOME}/ruby
ENV PATH ${RUNNER_USER_HOME}/bin:${GEM_HOME}/bin:${PATH}
ENV DEBIAN_FRONTEND noninteractive

COPY base/bin/prepare /tmp/devon_rex_work/
RUN /tmp/devon_rex_work/prepare

# Install Git and verify the specified version of Git is installed
COPY --from=git-builder /opt/git /
RUN test "$(git --version)" = "git version 2.27.0"

# Install Ruby
COPY --from=ruby:2.7.1 /usr/local /usr/local/

# Change USER and prepare Bundler
USER $RUNNER_USER
RUN gem update --system && \
    # NOTE: Install bundler v1 as well as v2 because runner applications need them
    #       in order to parse both versions of Gemfile.lock.
    #       See https://bunndler.io/blog/2019/01/03/announcing-bundler-2.html
    gem install bundler:"${BUNDLER1_VERSION}" && \
    gem install bundler:"${BUNDLER2_VERSION}" && \
    # Verify Bundler installation
    test "$(bundle -v)" = "Bundler version ${BUNDLER2_VERSION}" || (echo 'Unexpected Bundler version!' ; exit 1) && \
    gem info bundler && \
    gem environment && \
    ruby -v && gem -v && bundle -v


# Install pyenv
USER $RUNNER_USER
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
ARG PYENV_SHIMS_BIN="$RUNNER_USER_HOME/.pyenv/shims"
ARG PYENV_BIN="$RUNNER_USER_HOME/.pyenv/bin"
ENV PATH $PYENV_SHIMS_BIN:$PYENV_BIN:$PATH
ENV PYTHON2_VERSION 2.7.16
ENV PYTHON3_VERSION 3.8.2

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
