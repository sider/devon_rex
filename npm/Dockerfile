FROM sider/devon_rex_base:dev

ENV NODE_VERSION=11.15.0
ENV NPM_VERSION=6.10.1
ENV YARN_VERSION=1.17.3

RUN cd /tmp \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt" \
    && grep "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt | sha256sum --check --strict \
    && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
    && rm -rf "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt

RUN npm install -g npm@$NPM_VERSION

RUN cd /tmp \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
    && curl -fsSL --compressed "https://dl.yarnpkg.com/debian/pubkey.gpg" | gpg --import \
    && gpg --verify "yarn-v$YARN_VERSION.tar.gz.asc" \
    && tar -xzf "yarn-v$YARN_VERSION.tar.gz" -C /usr/local --strip-components=1 \
    && rm -rf "yarn-v$YARN_VERSION.tar.gz" "yarn-v$YARN_VERSION.tar.gz.asc"
