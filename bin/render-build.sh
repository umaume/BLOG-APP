#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run database migrations
bundle exec rails db:create RAILS_ENV=production
bundle exec rails db:migrate RAILS_ENV=production