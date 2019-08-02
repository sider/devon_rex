FROM sider/devon_rex_base:dev

ENV JAVA_VERSION 12.0.1

RUN cd /tmp \
  && curl -fsSLO --compressed "https://download.java.net/java/GA/jdk${JAVA_VERSION}/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" \
  && curl -fsSL -o sha256.txt --compressed "https://download.java.net/java/GA/jdk${JAVA_VERSION}/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz.sha256" \
  && echo "$(cat sha256.txt) *openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" | sha256sum --check --strict \
  && mkdir -p /usr/local/java \
  && tar -xzf "openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" -C /usr/local/java --strip-components=1 \
  && rm -rf "openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" sha256.txt

ENV PATH /usr/local/java/bin:$PATH

# Edit secure_path
RUN sed -i -e '/secure_path/d' /etc/sudoers && \
    echo "Defaults secure_path=/usr/local/java/bin:/usr/local/bin:/usr/bin:/bin" >> /etc/sudoers
