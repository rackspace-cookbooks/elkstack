# Encoding: utf-8

require_relative 'spec_helper'

describe service('logstash-forwarder') do
  it { should be_running }
end

describe 'logstash-forwarder service' do
  # can't use process() matcher because of two java processes
  describe 'should be running Logstash main class' do
    describe command('ps aux | grep -v grep | grep -s /opt/logstash-forwarder/bin/logstash-forwarder') do
      its(:exit_status) { should eq 0 }
    end
  end
end

describe 'lumberjack keypair' do
  describe file('/opt/logstash/lumberjack.crt') do
    it { should be_file }
  end

  describe file('/opt/logstash/lumberjack.key') do
    it { should be_file }
  end
end

describe file('/etc/logstash-forwarder') do
  it { should be_file }
  it { should contain '"ssl certificate": "/opt/logstash/lumberjack.crt"' }
  it { should contain '"ssl key": "/opt/logstash/lumberjack.key"' }
  it { should contain '"ssl ca": "/opt/logstash/lumberjack.crt"' }

  it { should contain '"1.2.3.4:5960"' }
  it { should contain '"1.2.3.5:5960"' }
  it { should contain '"/var/log/messages"' }
end
