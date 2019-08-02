FROM sider/devon_rex_base:base

# Install pyenv
USER $RUNNER_USER
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
ENV PYENV_SHIMS_BIN="$RUNNER_USER_HOME/.pyenv/shims"
ENV PYENV_BIN="$RUNNER_USER_HOME/.pyenv/bin"
ENV PATH="$PYENV_SHIMS_BIN:$PYENV_BIN:$PATH"

# Install python 2 and 3
RUN pyenv install 2.7.16 \
  && pyenv install 3.7.3 \
  && pyenv rehash        \
  && pyenv global 3.7.3

# Edit secure_path to include PATH required by Python
USER root
RUN sed -i -e '/secure_path/d' /etc/sudoers && \
    echo "Defaults secure_path=\"$GEM_HOME/bin:$PYENV_SHIMS_BIN:$PYENV_BIN:/usr/local/bin:/usr/bin:/bin\"" >> /etc/sudoers
