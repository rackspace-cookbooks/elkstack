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

      # stub an additional template
      node.set['elkstack']['config']['custom_logstash']['name'] = ['foo']
      node.set['elkstack']['config']['custom_logstash']['foo']['name'] = 'my_logstashconfig'
      node.set['elkstack']['config']['custom_logstash']['foo']['source'] = 'my_logstashconfig.conf.erb'
      node.set['elkstack']['config']['custom_logstash']['foo']['cookbook'] = 'your_cookbook'
      node.set['elkstack']['config']['custom_logstash']['foo']['variables'] = { warning: 'foo' }
    end.converge(described_recipe)
  end

  it 'creates additional custom config files' do
    expect(chef_run).to create_logstash_config('agent')
  end
end

describe 'elkstack::logstash' do
  let(:chef_run) do
    stub_resources
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['filesystem'] = []
      node.set['platformstack']['elkstack_logging']['enabled'] = true

      # stub an additional template
      node.set['elkstack']['config']['custom_logstash']['name'] = ['foo']
      node.set['elkstack']['config']['custom_logstash']['foo']['name'] = 'my_logstashconfig'
      node.set['elkstack']['config']['custom_logstash']['foo']['source'] = 'my_logstashconfig.conf.erb'
      node.set['elkstack']['config']['custom_logstash']['foo']['cookbook'] = 'your_cookbook'
      node.set['elkstack']['config']['custom_logstash']['foo']['variables'] = { warning: 'foo' }
    end.converge(described_recipe)
  end

  it 'creates additional custom config files' do
    expect(chef_run).to create_logstash_config('default')
  end
end
