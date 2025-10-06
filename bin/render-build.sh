#!/usr/bin/env bash
# exit on error
set -o errexit

# Debug environment variables
echo "==> Debugging environment variables"
echo "DATABASE_URL: ${DATABASE_URL}"
echo "RAILS_ENV: ${RAILS_ENV}"

# Install dependencies
bundle install

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Database setup (create if not exists, then migrate)
echo "==> Setting up database"
bundle exec rails db:prepare RAILS_ENV=production