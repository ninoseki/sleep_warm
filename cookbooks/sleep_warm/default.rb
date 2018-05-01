# install Ruby 2.4
"git build-essential".split.each { |name| package name }

execute "yes | sudo apt-add-repository ppa:brightbox/ruby-ng" do
  not_if "grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep brightbox-ubuntu-ruby-ng"
end

execute "sudo apt-get update" do
  not_if "dpkg -l ruby2.4"
end

"ruby2.4 ruby2.4-dev ruby-switch".split.each { |name| package name }

execute "sudo ruby-switch --set ruby 2.4" do
  not_if "ruby -v | grep 2.4"
end

gem_package "bundler"

# install sleep_warm
user "sleep-warm" do
  home "/home/sleep-warm"
  shell "/bin/bash"
  create_home true
end

execute "git clone https://github.com/ninoseki/sleep_warm.git -b WIP /opt/sleep-warm" do
  not_if "test -d /opt/sleep-warm"
end

execute "bundle install --path vendor/bundle" do
  cwd "/opt/sleep-warm"
  user "sleep-warm"
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
["sudo systemctl daemon-reload", "sudo systemctl enable sleep-warm", "sudo systemctl start sleep-warm"].each do |command|
  execute command
end
