describe user('logstash') do
  it { should exist }
  it { should belong_to_group 'logstash' }
  it { should have_home_directory '/var/lib/logstash' }
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
