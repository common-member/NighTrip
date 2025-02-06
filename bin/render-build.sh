set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails db:seed
