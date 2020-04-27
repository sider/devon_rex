# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM openjdk:14.0.1-buster

ENV GLOBAL_RUBY_VERSION 2.7.1
ENV BUNDLER1_VERSION 1.17.3
ENV BUNDLER2_VERSION 2.1.4
ENV LANG en_US.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV RUNNER_USER analyzer_runner
ENV RUNNER_GROUP nogroup
ENV RUNNER_USER_HOME /home/${RUNNER_USER}
ENV RUNNER_RUBY_HOME ${RUNNER_USER_HOME}/ruby
ENV PATH ${RUNNER_USER_HOME}/bin:${RUNNER_RUBY_HOME}/bin:${PATH}
ENV DEBIAN_FRONTEND noninteractive

COPY base/bin/prepare /tmp/devon_rex_work/
RUN /tmp/devon_rex_work/prepare

USER $RUNNER_USER

COPY base/bin/build-ruby /tmp/devon_rex_work/
RUN RUBY_BUILD_VERSION="20200401" /tmp/devon_rex_work/build-ruby
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} base/etc/gemrc ${RUNNER_RUBY_HOME}/etc/
RUN gem environment


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

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD ["java", "-version"]
