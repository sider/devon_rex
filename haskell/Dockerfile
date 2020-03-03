# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: The base image is `debian:stretch` but we uses basically `debian:buster`.
#       See https://github.com/freebroccolo/docker-haskell/issues/94
#
# NOTE: The version `8.6.5` is not latest and is including Cabal 2.4 (not latest too).
#       Because ShellCheck does not work yet on the both latest versions.
#       See https://github.com/koalaman/shellcheck/blob/de9ab4e6ef5262eeba6871a03ef3938a93b44395/ShellCheck.cabal#L40
FROM haskell:8.6.5

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

USER $RUNNER_USER
RUN /tmp/devon_rex_work/build-ruby
ENV PATH ${RUNNER_USER_HOME}/.rbenv/shims:${RUNNER_USER_HOME}/.rbenv/bin:${PATH}

USER root
RUN rm -rf /tmp/devon_rex_work

# Following instructions should be run by a non-root user
USER $RUNNER_USER


CMD ghci --version && cabal --version
