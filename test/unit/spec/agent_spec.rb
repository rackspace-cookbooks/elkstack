# Encoding: utf-8

require_relative 'helpers/spec_helper'

describe 'elkstack::agent' do
  let(:chef_run) do
    stub_resources
    ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['filesystem'] = []
      node.set['platformstack']['elkstack_logging']['enabled'] = true
    end.converge(described_recipe)
  end

  it 'includes the _agent, elasticsearch::search_discovery, _secrets, and rsyslog::client recipes' do
    expect(chef_run).to include_recipe('elkstack::agent')
    expect(chef_run).to include_recipe('elasticsearch::search_discovery')
    expect(chef_run).to include_recipe('elkstack::_secrets')
    expect(chef_run).to include_recipe('rsyslog::client')
  end

  it 'creates an instance, service, pattern and config for the agent' do
    # enable includes start in LWRP in logstash cookbook
    expect(chef_run).to enable_logstash_service('agent')

    expect(chef_run).to create_logstash_instance('agent')
    expect(chef_run).to create_logstash_pattern('agent')
    expect(chef_run).to create_logstash_config('agent')
  end

  it 'creates lumberjack key and certificate files' do
    expect(chef_run).to create_file('/opt/logstash/lumberjack.key')
    expect(chef_run).to create_file('/opt/logstash/lumberjack.crt')
  end
end
