#!/bin/bash

sudo service nginx start
cd /backend
RAILS_ENV=production bin/rails db:migrate
bin/setup
bundle exec pumactl start