ARG RUBY_MAJOR
FROM ghcr.io/publishing-platform/publishing-platform-ruby-base:${RUBY_MAJOR}

RUN install_packages \
    g++ git gpg libc-dev libcurl4-openssl-dev libgdbm-dev libssl-dev \
    libmariadb-dev-compat libpq-dev libjsonnet-dev libyaml-dev make xz-utils

# Environment variables to make build cleaner and faster
ENV BUNDLE_IGNORE_MESSAGES=1 \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_JOBS=12 \
    MAKEFLAGS="-j12"
RUN echo 'gem: --no-document' >> /etc/gemrc

ENV SECRET_KEY_BASE_DUMMY=1

LABEL org.opencontainers.image.source=https://github.com/publishing-platform/publishing-platform-ruby-images