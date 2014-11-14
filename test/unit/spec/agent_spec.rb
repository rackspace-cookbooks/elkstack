# Encoding: utf-8

require_relative 'spec_helper'

describe 'elkstack::agent' do
  let(:chef_run) do
    stub_resources
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['filesystem'] = []
      node.set['platformstack']['elkstack_logging']['enabled'] = true
      node.set['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = '127.0.0.1'
    end.converge(described_recipe)
  end

  it 'includes the _agent, elasticsearch::search_discovery, _secrets, and rsyslog::client recipes' do
    expect(chef_run).to include_recipe('elkstack::agent')
    # Not with chef-solo.
    # expect(chef_run).to include_recipe('elasticsearch::search_discovery')
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

# shouldn't run the agent (should exit without servers set)
describe 'elkstack::agent without setting cluster nodes' do
  let(:chef_run) do
    stub_resources
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['filesystem'] = []
      node.set['platformstack']['elkstack_logging']['enabled'] = true
    end.converge('elkstack::agent')
  end

  it 'includes the _agent, elasticsearch::search_discovery, _secrets, and rsyslog::client recipes' do
    expect(chef_run).to include_recipe('elkstack::agent')
    # Not with chef-solo.
    # expect(chef_run).to include_recipe('elasticsearch::search_discovery')
    expect(chef_run).to_not include_recipe('elkstack::_secrets')
    expect(chef_run).to_not include_recipe('rsyslog::client')
  end
end

# shouldn't run the agent (should exit since logging=false)
describe 'elkstack::agent with logging explicitly disabled' do
  let(:chef_run) do
    stub_resources
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['filesystem'] = []
      node.set['platformstack']['elkstack_logging']['enabled'] = false
    end.converge('elkstack::agent')
  end

  it 'includes the _agent, elasticsearch::search_discovery, _secrets, and rsyslog::client recipes' do
    expect(chef_run).to include_recipe('elkstack::agent')
    # Not with chef-solo.
    # expect(chef_run).to include_recipe('elasticsearch::search_discovery')
    expect(chef_run).to_not include_recipe('elkstack::_secrets')
    expect(chef_run).to_not include_recipe('rsyslog::client')
  end
end

# shouldn't run the agent (should do logging=true implicitly, but exit with no servers)
describe 'elkstack::agent with no servers but no logging set' do
  let(:chef_run) do
    stub_resources
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['filesystem'] = []
    end.converge('elkstack::agent')
  end

  it 'includes the _agent, elasticsearch::search_discovery, _secrets, and rsyslog::client recipes' do
    expect(chef_run).to include_recipe('elkstack::agent')
    # Not with chef-solo.
    # expect(chef_run).to include_recipe('elasticsearch::search_discovery')
    expect(chef_run).to_not include_recipe('elkstack::_secrets')
    expect(chef_run).to_not include_recipe('rsyslog::client')
  end
end
