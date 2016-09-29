#!/bin/bash
export PATH=$PATH:/opt/chef/embedded/bin

sudo /opt/chef/embedded/bin/gem install bundler --no-ri --no-rdoc
cd /tmp/tests
bundle install --path=vendor
bundle exec rake spec
