# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM debian:buster-20210621 AS git-builder

ARG GIT_PREFIX=/opt/git
ARG GIT_VERSION=2.32.0
ARG GIT_SOURCE_TARBALL=git-${GIT_VERSION}.tar.xz
ARG GIT_SOURCE_URL=https://mirrors.edge.kernel.org/pub/software/scm/git/${GIT_SOURCE_TARBALL}
ARG GIT_SOURCE_SHA256_URL=https://mirrors.edge.kernel.org/pub/software/scm/git/sha256sums.asc
ARG DEBIAN_FRONTEND=noninteractive

# See:
# - https://git-scm.com/book/en/v2/Getting-Started-Installing-Git#_installing_from_source
# - https://github.com/git/git/blob/v2.32.0/INSTALL
# - https://github.com/git/git/blob/v2.32.0/Makefile
RUN apt-get update -y && \
    apt-get install -qq -y --no-install-recommends \
      dh-autoreconf \
      libcurl4-gnutls-dev \
      libexpat1-dev \
      libz-dev \
      libssl-dev \
      curl \
      ca-certificates \
      ;
RUN curl -fsSLO --compressed "${GIT_SOURCE_URL}" && \
    curl -fsSL --compressed "${GIT_SOURCE_SHA256_URL}" | \
      grep "${GIT_SOURCE_TARBALL}" | \
      sha256sum --check --strict && \
    tar -xf "${GIT_SOURCE_TARBALL}" && \
    cd "git-${GIT_VERSION}" && \
    make configure && \
    ./configure --prefix="${GIT_PREFIX}" --without-tcltk && \
    make "-j$(nproc)" NO_GETTEXT=1 install


FROM php:7.4.21-buster

ENV GLOBAL_RUBY_VERSION 2.7.3
ENV LANG en_US.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV RUNNER_USER analyzer_runner
ENV RUNNER_GROUP nogroup
ENV RUNNER_USER_HOME /home/${RUNNER_USER}
ENV RUNNER_USER_BIN ${RUNNER_USER_HOME}/bin
ENV GEM_HOME ${RUNNER_USER_HOME}/ruby
ENV PATH ${RUNNER_USER_BIN}:${GEM_HOME}/bin:${PATH}
ENV DEBIAN_FRONTEND noninteractive

COPY base/bin/prepare /tmp/devon_rex_work/
RUN /tmp/devon_rex_work/prepare

# Install Git and verify the specified version of Git is installed
COPY --from=git-builder /opt/git /opt/git
ENV PATH /opt/git/bin:${PATH}
RUN test "$(git --version)" = "git version 2.32.0" && \
    git clone --quiet --depth=1 https://github.com/sider/devon_rex.git && \
    rm -rf devon_rex

# Install Ruby
COPY --from=ruby:2.7.3 /usr/local /usr/local/

# Change owner to let $RUNNER_USER add certificate files
# WARNING: This must be done after copying ruby:2.7.2
RUN chown "$RUNNER_USER" /usr/local/share/ca-certificates

# Update the system `gem` and `bundler`. `GEM_HOME` is created automatically by the root user, so `chown` is needed.
RUN gem update --system && \
    chown -R "${RUNNER_USER}:${RUNNER_GROUP}" "${GEM_HOME}"

# Change USER and prepare Bundler
COPY Gemfile /tmp/devon_rex_work/
USER $RUNNER_USER
RUN bundler_version=$(grep --word-regexp 'bundler' /tmp/devon_rex_work/Gemfile | grep --only-matching --extended-regexp '[0-9.]+') && \
    # Verify Bundler installation
    actual_bundler_version=$(bundle -v) && \
    test "${actual_bundler_version}" = "Bundler version ${bundler_version}" || (echo "Unexpected Bundler version! ${actual_bundler_version}" ; exit 1) && \
    # NOTE: Install bundler v1 as well as v2 because runner applications need them
    #       in order to parse both versions of Gemfile.lock.
    #       See https://bunndler.io/blog/2019/01/03/announcing-bundler-2.html
    gem install bundler:1.17.3 && \
    gem info bundler && \
    gem environment && \
    ruby -v && \
    gem -v && \
    bundle -v


USER root

# PHP configuration
RUN mv "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"
COPY php/sider.ini ${PHP_INI_DIR}/conf.d/sider.ini

# Install Composer - https://getcomposer.org/download/
ARG COMPOSER_VERSION=1.10.22
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version="${COMPOSER_VERSION}" && \
    php -r "unlink('composer-setup.php');" && \
    composer --version | grep "Composer version ${COMPOSER_VERSION} "
ENV COMPOSER_HOME ${RUNNER_USER_HOME}/.composer
ENV COMPOSER_VENDOR_BIN ${COMPOSER_HOME}/vendor/bin
ENV PATH ${COMPOSER_VENDOR_BIN}:$PATH

USER $RUNNER_USER
RUN mkdir -p "${COMPOSER_VENDOR_BIN}"

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD ["php", "--version"]
