# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t my-app .
# docker run -d -p 80:80 -p 443:443 --name my-app -e RAILS_MASTER_KEY=<value from config/master.key> my-app

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        sudo \
        vim \
        git \
        curl \
        libjemalloc2 \
        libvips \
        libpq-dev \
        postgresql-client \
        sqlite3 \
        nodejs \
    && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    # MOVE TO GITHUB ENV AND INJECT ON BUILD
    RAILS_RELATIVE_URL_ROOT="" \
    SECRET_KEY_BASE="1a67dab935ceebdc7a18918fd8e75eeeb1b32a3f2d0b9839587f3ef074595f9eadaeb125ba41ce0edf6a769a630cb34502c66504f17acc6e15fd2f736af634b8" \
    DB_HOST="database-dev-1.cluwc2ok61uc.eu-north-1.rds.amazonaws.com" \
    DB_NAME="cpe4254-webforum-app" \
    DB_USERNAME="cpe4254-webforum-app" \
    DB_PASSWORD="0806849422a"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        pkg-config \
    && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY

# TODO:EXAMINE THIS COMMAND AGAIN
RUN SECRET_KEY_BASE=1a67dab935ceebdc7a18918fd8e75eeeb1b32a3f2d0b9839587f3ef074595f9eadaeb125ba41ce0edf6a769a630cb34502c66504f17acc6e15fd2f736af634b8 \
    ./bin/rails assets:precompile
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile



# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
# TODO:EXAMINE THESE COMMANDS AGAIN
# RUN groupadd --system --gid 1000 rails && \
#    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
#    chown -R rails:rails db log storage tmp
# USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
# EXPOSE 3000

# USE ENV INSTEAD AND MAKE THIS TO BE DEFAULT (FALLBACK)
EXPOSE 3000

CMD ["./bin/rails", "server"]
