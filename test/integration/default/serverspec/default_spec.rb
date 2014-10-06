# Encoding: utf-8

require_relative 'spec_helper'

describe command('java -version') do
  its(:exit_status) { should eq 0 }
end

describe command('ruby -v') do
  its(:exit_status) { should eq 0 }
end

describe command('python -V') do
  its(:exit_status) { should eq 0 }
end

require_relative 'elasticsearch'
require_relative 'logstash'
require_relative 'end2end'
require_relative 'kibana'
