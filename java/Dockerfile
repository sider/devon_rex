# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM debian:buster-20201012 AS git-builder

ARG GIT_VERSION=2.28.0
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


FROM openjdk:15.0.1-buster

ENV GLOBAL_RUBY_VERSION 2.7.2
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
RUN test "$(git --version)" = "git version 2.28.0"

# Install Ruby
COPY --from=ruby:2.7.2 /usr/local /usr/local/

# Change owner to let $RUNNER_USER add certificate files
# WARNING: This must be done after copying ruby:2.7.2
RUN chown "$RUNNER_USER" /usr/local/share/ca-certificates

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


SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Maven
ARG MAVEN_VERSION=3.6.3
ARG MAVEN_BINARY_URL=https://www.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
ARG MAVEN_BINARY_FILE=apache-maven-${MAVEN_VERSION}-bin.tar.gz
ARG MAVEN_HOME=${RUNNER_USER_HOME}/maven
ENV PATH ${MAVEN_HOME}/bin:${PATH}
RUN cd "${RUNNER_USER_HOME}" && \
    curl -fsSLO --compressed "${MAVEN_BINARY_URL}" && \
    curl -fsSL  --compressed "${MAVEN_BINARY_URL}.sha512" | \
      xargs -I {} echo "{} *${MAVEN_BINARY_FILE}" | \
      sha512sum --check --strict && \
    mkdir -p "${MAVEN_HOME}" && \
    tar -xzf "${MAVEN_BINARY_FILE}" -C "${MAVEN_HOME}" --strip-components 1 && \
    rm "${MAVEN_BINARY_FILE}" && \
    mvn -v

# Install Gradle
ENV PATH ${RUNNER_USER_HOME}/gradle/bin:${PATH}
ARG GRADLE_VERSION=6.7
ARG GRADLE_BINARY_FILE=gradle-${GRADLE_VERSION}-bin.zip
ARG GRADLE_BINARY_URL=https://services.gradle.org/distributions/${GRADLE_BINARY_FILE}
RUN cd "${RUNNER_USER_HOME}" && \
    curl -fsSLO --compressed "${GRADLE_BINARY_URL}" && \
    curl -fsSL  --compressed "${GRADLE_BINARY_URL}.sha256" | \
      xargs -I {} echo "{} *${GRADLE_BINARY_FILE}" | \
      sha256sum --check --strict && \
    unzip -q "${GRADLE_BINARY_FILE}" && \
    mv "gradle-${GRADLE_VERSION}" gradle && \
    rm "${GRADLE_BINARY_FILE}" && \
    gradle -v

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD ["java", "-version"]
