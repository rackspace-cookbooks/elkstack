# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: logstash
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

logstash_instance 'server' do
  action 'create'
end

logstash_service 'server' do
  action :enable
end

my_templates = {
  'input_syslog' => 'config/input_syslog.conf.erb',
  'output_stdout' => 'config/output_stdout.conf.erb',
  'output_elasticsearch' => 'config/output_elasticsearch.conf.erb'
}

logstash_config 'server' do
  action 'create'
  templates my_templates
  templates_cookbook 'elkstack'
  # don't need notifies since the LWRP does it
end

logstash_service 'server' do
  action :start
end

# Cloud monitoring currently doesn't provide a hook to push in files from git, just from the cookbook.
# If the check is enabled, push the file ourselves and configure the monitor.
if node['elkstack']['cloud_monitoring']['process_logstash']['disabled'] == 'false' do
  process_name = 'logstash'

  # make sure directory structure exists
  directory '/usr/lib/rackspace-monitoring-agent/plugins' do
    action :create_if_missing
  end

  # drop the file
  remote_file '/usr/lib/rackspace-monitoring-agent/plugins/process_mon.sh' do
    owner 'root'
    group 'root'
    mode 00755
    source "https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/process_mon.sh"
  end

  # setup the monitor
  template "process-monitor-#{process_name}-#{site['server_name']}" do
    cookbook 'elkstack'
    source 'monitoring-process.yaml.erb'
    path "/etc/rackspace-monitoring-agent.conf.d/#{site['server_name']}-#{process_name}-monitor.yaml"
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      server_name: site['server_name'],
      process_name: process_name
    )
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
  end
end
