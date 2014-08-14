# Encoding: utf-8

require_relative 'spec_helper'

describe port(9200) do
  it { should be_listening }
end

describe port(80) do
  it { should be_listening }
end

describe process('nginx') do
  it { should be_running }
end

describe process('java') do
  its(:args) { should match(/logstash/) }
end
