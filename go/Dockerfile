FROM sider/devon_rex_base:dev

ENV GO_VERSION 1.8
ENV GO_DOWNLOAD_SHA256 53ab94104ee3923e228a2cb2116e5e462ad3ebaeea06ff04463479d7f12d27ca

# Install go from binary distributions. https://golang.org/dl/
RUN cd /tmp \
  && curl -fsSLO --compressed "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" \
  && echo "${GO_DOWNLOAD_SHA256} *go${GO_VERSION}.linux-amd64.tar.gz" | sha256sum --check --strict \
  && tar -xzf "go${GO_VERSION}.linux-amd64.tar.gz" -C /usr/local \
  && rm -rf "go${GO_VERSION}.linux-amd64.tar.gz"

RUN add-apt-repository ppa:masterminds/glide \
  && apt-get update \
  && apt-get install glide \
  && rm -rf /var/lib/apt/lists/*

ENV GOROOT=/usr/local/go \
    GOPATH=$RUNNER_USER_HOME/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# Edit secure_path to include PATH required by Go
USER root
RUN sed -i -e '/secure_path/d' /etc/sudoers && \
    echo "Defaults secure_path=\"$GEM_HOME/bin:/usr/local/bin:/usr/bin:/bin:$GOROOT/bin:$GOPATH/bin\"" >> /etc/sudoers
