set -o errexit

bundle install
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake assets:precompile
bundle exec rake assets:clean
