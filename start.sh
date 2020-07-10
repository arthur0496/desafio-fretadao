#!/bin/sh

# Exporting all environment variables to use in crontab
env | sed 's/^\(.*\)$/ \1/g' > /root/env

function_postgres_ready() {
python << END
import socket
import time
import os

port = int(os.environ["PG_PORT"])

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.connect(('challenge_db', port))
s.close()
END
}


bundle check || bundle install
rails webpacker:install

until function_postgres_ready; do
  >&2 echo "Postgres is unavailable - sleeping..."
  sleep 1
done
>&2 echo "Postgres is up - executing commands..."


if [ -f $pidfile ] ; then
  echo 'Server PID file exists. Removing it...'
  rm $pidfile
fi

# If database exists, migrate. Otherwise, create and seed
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup db:seed
echo "Database setup complete! Running the server."

bundle exec rails s -p 3000 -b 0.0.0.0
