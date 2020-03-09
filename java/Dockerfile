# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM debian:buster-20200224

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


USER root

# Install Java
ENV JAVA_VERSION 12.0.2
ENV PATH /usr/local/java/bin:${PATH}
ARG JAVA_BINARY_URL=https://download.java.net/java/GA/jdk${JAVA_VERSION}/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz
ARG JAVA_BINARY_FILE=openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz
RUN curl -fsSLO --compressed "${JAVA_BINARY_URL}" && \
    curl -fsSL  --compressed "${JAVA_BINARY_URL}.sha256" | \
      xargs -I {} echo "{} *${JAVA_BINARY_FILE}" | \
      sha256sum --check --strict && \
    mkdir -p /usr/local/java && \
    tar -xzf "${JAVA_BINARY_FILE}" -C /usr/local/java --strip-components=1 && \
    rm "${JAVA_BINARY_FILE}"

# Install Maven
ENV MAVEN_VERSION 3.6.3
ENV PATH /usr/local/maven/bin:$PATH
ARG MAVEN_BINARY_URL=https://www.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
ARG MAVEN_BINARY_FILE=apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN curl -fsSLO --compressed "${MAVEN_BINARY_URL}" && \
    curl -fsSL  --compressed "${MAVEN_BINARY_URL}.sha512" | \
      xargs -I {} echo "{} *${MAVEN_BINARY_FILE}" | \
      sha512sum --check --strict && \
    mkdir -p /usr/local/maven && \
    tar -xzf "${MAVEN_BINARY_FILE}" -C /usr/local/maven --strip-components 1 && \
    rm "${MAVEN_BINARY_FILE}"

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD java -version && javac -version && mvn -v
