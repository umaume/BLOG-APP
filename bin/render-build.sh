#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Database setup (create if not exists, then migrate)
bundle exec rails db:prepare RAILS_ENV=production