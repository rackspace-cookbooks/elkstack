# Encoding: utf-8

require_relative 'spec_helper'

describe 'java was installed and available' do
  describe command('java -version') do
    its(:exit_status) { should eq 0 }
  end
end

describe 'logstash was installed and started as a service' do
  describe user('logstash') do
    it { should exist }
    it { should belong_to_group 'logstash' }
  end

  describe port(5959) do
    it { should be_listening }
  end

  describe service('logstash_agent') do
    it { should be_running }
  end

  describe 'should be running Logstash main class' do
    describe command('ps aux | grep -v grep | grep -s logstash/runner.rb') do
      # can't use process() matcher because of two java processes
      its(:exit_status) { should eq 0 }
    end
  end
end

describe 'logstash had a valid configuration file that passes its own checks' do
  describe command('/opt/logstash/agent/bin/logstash agent -f /opt/logstash/agent/etc/conf.d/ -t 2>&1 | grep -s "Configuration OK"') do
    its(:exit_status) { should eq 0 }
  end

  describe 'lumberjack keypair' do
    describe file('/opt/logstash/lumberjack.crt') do
      it { should be_file }
    end

    describe file('/opt/logstash/lumberjack.key') do
      it { should be_file }
    end
  end
end

describe 'on supplying a custom logstash configuration file' do
  describe file('/opt/logstash/agent/etc/conf.d/input_test.conf') do
    it { should be_file }
    its(:content) { should match(/special_test_path/) }
  end
end
