
logline = "#{Time.now.to_i}-elkstack-test"

if os[:family] == 'redhat'
  messages = '/var/log/messages'
else
  messages = '/var/log/syslog'
end

describe 'sending a test line to /usr/bin/logger should reach elasticsearch' do
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
    describe command("sleep 30 && curl -s -XGET 'http://localhost:9200/_search?q=#{logline}' 2>&1 | grep -sq '#{logline}'") do
      its(:exit_status) { should eq 0 }
    end
  end
end
