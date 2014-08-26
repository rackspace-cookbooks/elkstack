
logline = "#{Time.now.to_i}-elkstack-test"

if os[:family] == 'RedHat'
  messages = '/var/log/messages'
else
  messages = '/var/log/syslog'
end

describe 'sending a test line to /usr/bin/logger should reach elasticsearch' do
  it 'should send a test line to syslog' do
    expect(command "logger #{logline}").to return_exit_status 0
    expect(command 'kill -HUP $(pgrep rsyslog)').to return_exit_status 0
  end
  it 'should see test log line in a file' do
    expect(command "grep '#{logline}' #{messages}").to return_exit_status 0
  end
  it 'should return test log line from elasticsearch' do
    expect(command "sleep 30 && curl -s -XGET 'http://localhost:9200/_search?q=#{logline}' 2>&1 | grep -sq '#{logline}'").to return_exit_status 0
  end
end
