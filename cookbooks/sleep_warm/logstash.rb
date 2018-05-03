"openjdk-8-jdk wget apt-transport-https".split.each { |name| package name }

execute "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -" do
  not_if "apt-key list | grep Elasticsearch"
end

remote_file "/etc/apt/sources.list.d/elastic-6.x.list"

execute "sudo apt-get update" do
  not_if "dpkg -l logstash"
end
package "logstash"

remote_file "/etc/logstash/conf.d/sleep-warm.conf"

execute "chown -R logstash:logstash /etc/logstash"

%i(enable start).each do |action|
  service "logstash" do
    action action
  end
end
