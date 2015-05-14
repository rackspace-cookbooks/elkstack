# Encoding: utf-8

require_relative 'spec_helper'

describe 'elkstack::default' do
  let(:chef_run) do
    stub_command("curl -sI http://eslocal:9200/_snapshot/elkstack | grep -q \"404 Not Found\"").and_return(0)
    ChefSpec::SoloRunner.new(platform: 'redhat', version: '6.5') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['chef_environment'] = '_default' # be a dummy env for htpasswd.curl
      node.set['rackspace']['cloud_credentials']['username'] = 'joe-test'
      node.set['rackspace']['cloud_credentials']['api_key'] = '123abc'
      node.set['filesystem'] = []
    end.converge(described_recipe)
    # converge WITH platformstack so we can test our templates are created
  end

  it 'installs ruby' do
    expect(chef_run).to install_package('ruby')
  end
end
