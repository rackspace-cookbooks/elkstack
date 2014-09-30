describe user('logstash') do
  it { should exist }
  it { should belong_to_group 'logstash' }
end

describe port(5959) do
  it { should be_listening }
end

describe service('logstash_server') do
  it { should be_running }
end

describe 'logstash' do
  # can't use process() matcher because of two java processes
  it 'should be running Logstash main class' do
    expect(command 'ps aux | grep -v grep | grep -s logstash/runner.rb')
    .to return_exit_status 0
  end
end

describe command('/opt/logstash/server/bin/logstash agent -f /opt/logstash/server/etc/conf.d/ -t 2>&1 | grep -s "Configuration OK"') do
  it { should return_exit_status 0 }
end

describe 'lumberjack keypair' do
  describe file('/opt/logstash/lumberjack.crt') do
    it { should be_file }
  end

  describe file('/opt/logstash/lumberjack.key') do
    it { should be_file }
  end
end
