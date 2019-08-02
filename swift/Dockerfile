FROM sider/devon_rex_base:dev

ENV DEBIAN_FRONTEND=noninteractive
ARG SWIFT_VERSION=4.2.3

RUN apt-get update && \
    apt-get install -y clang libpython2.7 libxml2 && \
    rm -rf /var/lib/apt/lists/*

# XXX: Of course, we should verify the package signature with gpg(1), but we cannot do
#      because quay.io builds often fail as a result of "gpg: keyserver communications error".
#      We check it with sha256sum(1) alternatively.
#
#      See https://swift.org/download to learn the verification methods.
#
RUN wget --no-verbose https://swift.org/builds/swift-$SWIFT_VERSION-release/ubuntu1604/swift-$SWIFT_VERSION-RELEASE/swift-$SWIFT_VERSION-RELEASE-ubuntu16.04.tar.gz && \
    echo "9d341ff0b20dd10e982209bdc7e0d137f7da0b5c6001b4ac8b4ae076e2e986c1  swift-${SWIFT_VERSION}-RELEASE-ubuntu16.04.tar.gz" | sha256sum --check - && \
    tar xvf swift-$SWIFT_VERSION-RELEASE-ubuntu16.04.tar.gz && \
    mv swift-$SWIFT_VERSION-RELEASE-ubuntu16.04/usr /usr/local/swift && \
    rm -rf swift-$SWIFT_VERSION-RELEASE-ubuntu16.04.tar.gz swift-$SWIFT_VERSION-RELEASE-ubuntu16.04

ENV PATH=/usr/local/swift/bin:$PATH
RUN sed -i -e '/secure_path/d' /etc/sudoers && \
    echo "Defaults secure_path=\"$GEM_HOME/bin:/usr/local/swift/bin:/usr/local/bin:/usr/bin:/bin\"" >> /etc/sudoers
