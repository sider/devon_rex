# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM php:7.4.3-buster

ENV GLOBAL_RUBY_VERSION 2.6.5
ENV BUNDLER1_VERSION 1.17.3
ENV BUNDLER2_VERSION 2.1.4
ENV DEVON_REX_RBENV_VERSION v1.1.2
ENV DEVON_REX_RUBY_BUILD_VERSION 20200224
ENV LANG en_US.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV RUNNER_USER analyzer_runner
ENV RUNNER_USER_HOME /home/$RUNNER_USER
ENV DEBIAN_FRONTEND=noninteractive

COPY base/bin/* /tmp/devon_rex_work/
RUN /tmp/devon_rex_work/prepare


# PHP configuration
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY php/sider.ini $PHP_INI_DIR/conf.d/sider.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_HOME $RUNNER_USER_HOME/.composer
ENV COMPOSER_VENDOR_BIN $COMPOSER_HOME/vendor/bin
ENV PATH $COMPOSER_VENDOR_BIN:$PATH

USER $RUNNER_USER
RUN mkdir -p $COMPOSER_VENDOR_BIN

USER $RUNNER_USER
RUN /tmp/devon_rex_work/build-ruby
ENV PATH ${RUNNER_USER_HOME}/.rbenv/shims:${RUNNER_USER_HOME}/.rbenv/bin:${PATH}

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD php -v && composer --version
