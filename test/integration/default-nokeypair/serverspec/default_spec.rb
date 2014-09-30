# Encoding: utf-8

require_relative 'spec_helper'

describe command('java -version') do
  it { should return_exit_status 0 }
end

describe command('ruby -v') do
  it { should return_exit_status 0 }
end

describe command('python -V') do
  it { should return_exit_status 0 }
end

require_relative 'elasticsearch'
require_relative 'logstash'
require_relative 'end2end'
require_relative 'kibana'
