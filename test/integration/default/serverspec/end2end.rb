
logline = "#{Time.now.to_i}-elkstack-test"

if os[:family] == 'redhat'
  messages = '/var/log/messages'
else
  messages = '/var/log/syslog'
end

describe 'sending a test line to /usr/bin/logger should reach elasticsearch' do
  describe 'should restart logstash before the test' do
    describe command('service logstash_server restart && sleep 30') do
      its(:exit_status) { should eq 0 }
    end
  end

  # kibana likes to create orphaned replica shards when it creates
  # a fresh index to store its own data within
  describe command('curl -XPUT localhost:9200/_settings -d\'{"number_of_replicas":0}\'') do
    its(:exit_status) { should eq 0 }
  end

  describe 'should send a test line to syslog' do
    describe command("logger #{logline}") do
      its(:exit_status) { should eq 0 }
    end
    describe command('kill -HUP $(pgrep rsyslog)') do
      its(:exit_status) { should eq 0 }
    end
  end
  describe 'should see test log line in a file' do
    describe command("grep '#{logline}' #{messages}") do
      its(:exit_status) { should eq 0 }
    end
  end
  describe 'should return test log line from elasticsearch' do
    describe command("sleep 60 && curl -s -XGET 'http://localhost:9200/_search?q=#{logline}' 2>&1 | grep -sq '#{logline}'") do
      its(:exit_status) { should eq 0 }
    end
  end
end
