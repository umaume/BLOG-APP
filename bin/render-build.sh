#!/usr/bin/env bash
# exit on error
set -o errexit

# Debug environment variables
echo "==> Debugging environment variables"
echo "DATABASE_URL: ${DATABASE_URL}"
echo "RAILS_ENV: ${RAILS_ENV}"
echo "RAILS_MASTER_KEY: ${RAILS_MASTER_KEY}"

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL is not set!"
    exit 1
fi

# Install dependencies
echo "==> Installing dependencies"
bundle install

# Precompile assets
echo "==> Precompiling assets"
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Database setup (create if not exists, then migrate)
echo "==> Setting up database with URL: $DATABASE_URL"
bundle exec rails db:prepare RAILS_ENV=production