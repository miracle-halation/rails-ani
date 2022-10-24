#!/bin/bash

sudo service nginx start
cd /backend
bin/setup
bundle exec pumactl start