# frozen_string_literal: true

# install Ruby 2.6
"git build-essential".split.each { |name| package name }

execute "yes | sudo apt-add-repository ppa:brightbox/ruby-ng" do
  not_if "grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep brightbox-ubuntu-ruby-ng"
end

execute "sudo apt-get update" do
  not_if "dpkg -l ruby2.6"
end

"ruby2.6 ruby2.6-dev ruby-switch".split.each { |name| package name }

execute "sudo ruby-switch --set ruby 2.6" do
  not_if "ruby -v | grep 2.6"
end

execute "sudo gem install bundler -v 2.0" do
  not_if "gem list | grep bundler | grep 2.0 "
end

# install sleep_warm
user "sleep-warm" do
  home "/home/sleep-warm"
  shell "/bin/bash"
  create_home true
end

git "/opt/sleep-warm" do
  repository "https://github.com/ninoseki/sleep_warm.git"
end

execute "bundle install --path vendor/bundle" do
  cwd "/opt/sleep-warm"
  not_if "bundle | grep installed"
end

directory "/var/log/sleep-warm" do
  owner "sleep-warm"
  group "sleep-warm"
end

remote_file "/etc/systemd/system/sleep-warm.service"
remote_file "/opt/sleep-warm/.env"

execute "sudo chown -R sleep-warm:sleep-warm /opt/sleep-warm"

# start the service
execute "sudo systemctl daemon-reload"
%i(enable start).each do |action|
  service "sleep-warm" do
    action action
  end
end
