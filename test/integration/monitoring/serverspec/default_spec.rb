# Encoding: utf-8

require_relative 'spec_helper'

rackspace_agent_confd = '/etc/rackspace-monitoring-agent.conf.d'

describe service('rackspace-monitoring-agent') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/rackspace-monitoring-agent.cfg') do
  it { should contain 'monitoring_token' }
end

# Elasticsearch
describe file("#{rackspace_agent_confd}/elasticsearch_service.yaml") do
  it { should contain 'elasticsearch-monitor.sh' }
end

describe file("#{rackspace_agent_confd}/elasticsearch.yaml") do
  it { should contain 'elasticsearch.py' }
end

describe file("#{rackspace_agent_confd}/tcp-elasticsearch-9200.yaml") do
  it { should contain 'Remote check for port 9200' }
end

describe file("#{rackspace_agent_confd}/tcp-elasticsearch-9300.yaml") do
  it { should contain 'Remote check for port 9300' }
end

# Logstash
describe file("#{rackspace_agent_confd}/logstash_service.yaml") do
  it { should contain 'logstash-monitor.sh' }
end

describe file("#{rackspace_agent_confd}/tcp-logstash-5959.yaml") do
  it { should contain 'Remote check for port 5959' }
end

# Kibana
describe file("#{rackspace_agent_confd}/nginx_service.yaml") do
  it { should contain 'nginx-monitor.sh' }
end

describe file("#{rackspace_agent_confd}/tcp-nginx-80.yaml") do
  it { should contain 'Remote check for port 80' }
end

describe file("#{rackspace_agent_confd}/tcp-nginx-443.yaml") do
  it { should contain 'Remote check for port 443' }
end
