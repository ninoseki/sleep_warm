# frozen_string_literal: true

package "ufw"

# set ufw rules
["sudo ufw default DENY", "sudo ufw allow 80/tcp", "sudo ufw allow 9292/tcp", "sudo ufw allow 2222/tcp", "sudo ufw allow 22/tcp"].each do |command|
  execute command
end

remote_file "/etc/ufw/before.rules" do
  owner "root"
  group "root"
end

["yes | sudo ufw enable", "sudo ufw reload"].each { |command| execute command }
