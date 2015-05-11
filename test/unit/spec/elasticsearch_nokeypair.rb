# Encoding: utf-8

require_relative 'spec_helper'

describe 'elkstack::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'redhat', version: '6.5') do |node|
      stub_resources

      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['chef_environment'] = '_default' # be a dummy env for htpasswd.curl
      node.set['rackspace']['cloud_credentials']['username'] = 'joe-test'
      node.set['rackspace']['cloud_credentials']['api_key'] = '123abc'
      node.set['filesystem'] = []

      node.set['elkstack']['config']['iptables'] = false
    end.converge(described_recipe)
  end

  it 'creates lumberjack keypairs when no data bags exist' do
    expect(chef_run).to_not create_file('/etc/lumberjack.key')
    expect(chef_run).to_not create_file('/etc/lumberjack.crt')
  end
end
