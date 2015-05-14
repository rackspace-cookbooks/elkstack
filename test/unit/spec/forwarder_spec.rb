# Encoding: utf-8

require_relative 'spec_helper'

describe 'elkstack::forwarder' do
  let(:chef_run) do
    stub_resources
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['filesystem'] = []
    end.converge(described_recipe)
  end

  it 'includes the _agent, elasticsearch::search_discovery, _secrets, and rsyslog::client recipes' do
    expect(chef_run).to include_recipe('elkstack::forwarder')
    expect(chef_run).to include_recipe('elkstack::_lumberjack_secrets')
  end

  it 'create service for the forwarder' do
    expect(chef_run).to enable_service('logstash-forwarder')
    expect(chef_run).to start_service('logstash-forwarder')
    expect(chef_run).to render_file('/etc/init.d/logstash-forwarder')
  end

  it 'creates lumberjack key and certificate files' do
    expect(chef_run).to create_file('/etc/lumberjack.key')
    expect(chef_run).to create_file('/etc/lumberjack.crt')
  end

  it 'installs logstash-forwarder pkg' do
    expect(chef_run).to install_package('logstash-forwarder')
    expect(chef_run).to add_apt_repository('logstash-forwarder')
  end

  it 'creates logstash-forwarder configuration file' do
    expect(chef_run).to create_file('/etc/logstash-forwarder')
  end
end
