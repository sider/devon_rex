FROM sider/devon_rex_base:dev

ARG PHP_VERSION="7.3.6"
# NOTE: To ignore .php-version in every project, we must set `RBENV_VERSION`.
#       Why rbenv? Because CHH/phpenv depends on rbenv.
#
#       If devon_rex_base uses rbenv, each runner based on this image must delete
#       .php-version before performing analysis.
ENV RBENV_VERSION="$PHP_VERSION"
ENV PHPENV_SHIMS_BIN="$RUNNER_USER_HOME/.phpenv/shims"
ENV PHPENV_BIN="$RUNNER_USER_HOME/.phpenv/bin"
ENV COMPOSER_HOME="$RUNNER_USER_HOME/.composer"
ENV COMPOSER_VENDOR_BIN="$COMPOSER_HOME/vendor/bin"
ENV PATH="$PHPENV_SHIMS_BIN:$PHPENV_BIN:$PATH:$COMPOSER_VENDOR_BIN"


# Install pear as root (and installs lib packages for building PHP)
RUN apt-get update \
    && apt-get install -y php-pear libtidy-dev libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Install phpenv as a general user
USER $RUNNER_USER
RUN curl https://raw.githubusercontent.com/CHH/phpenv/f347f96d0722c38033ff4a886c67de9d72634e6e/bin/phpenv-install.sh | bash \
    && git clone https://github.com/php-build/php-build.git ~/.phpenv/plugins/php-build \
    && cd ~/.phpenv/plugins/php-build && git checkout d1766006e0df4651a98cf8acd5684ad39088c349 \
    && phpenv install ${PHP_VERSION} \
    && phpenv global ${PHP_VERSION}
COPY sider.ini $RUNNER_USER_HOME/.phpenv/versions/${PHP_VERSION}/etc/conf.d/sider.ini

# Install composer as root
USER root
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Edit secure_path to include PATH required by PHP
USER root
RUN sed -i -e '/secure_path/d' /etc/sudoers && \
    echo "Defaults secure_path=\"$GEM_HOME/bin:$PHPENV_SHIMS_BIN:$PHPENV_BIN:/usr/local/bin:/usr/bin:/bin:$COMPOSER_VENDOR_BIN\"" >> /etc/sudoers && \
    echo 'Defaults env_keep += "RBENV_VERSION"' >> /etc/sudoers
