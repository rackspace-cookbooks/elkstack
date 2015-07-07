agent_name = node['elkstack']['config']['logstash']['agent_name']

default['elkstack']['config']['logstash']['agent']['my_templates'] = {
  'input_syslog'         => 'logstash/input_syslog.conf.erb'
}

# node.default['elkstack']['config']['logstash']['my_templates'] = {
#   'input_syslog'         => 'logstash/input_syslog.conf.erb',
#   'output_stdout'        => 'logstash/output_stdout.conf.erb'
# }

agent = normal['logstash']['instance'][agent_name]

agent['bind_host_interface'] = '127.0.0.1'
agent['enable_embedded_es'] = false
agent['basedir'] = '/opt/logstash'
agent['install_type'] = 'tarball'
agent['version'] = '1.4.2'
agent['checksum'] = 'd5be171af8d4ca966a0c731fc34f5deeee9d7631319e3660d1df99e43c5f8069'
agent['source_url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz'
agent['user'] = 'logstash'
agent['group'] = 'logstash'
agent['user_opts'] = { homedir: '/var/lib/logstash', uid: nil, gid: nil }
agent['logrotate_enable']  = true
agent['logrotate_options'] = %w(missingok notifempty compress copytruncate)
agent['logrotate_frequency'] = 'daily'
agent['logrotate_max_backup'] = 10
agent['logrotate_max_size'] = '10M'
agent['logrotate_use_filesize'] = false

# restrict logstash to 10% of the box, starting at 256M
node_memory = (node['memory']['total'].to_i * 0.1).floor / 1024
agent['xmx'] = node_memory >= 256 ? "#{node_memory}M" : '256M' # ensure that max is always bigger or equal to min
agent['xms'] = '256M'

agent['pattern_templates_cookbook'] = 'logstash'
agent['base_config_cookbook'] = 'logstash'
agent['config_templates_cookbook'] = 'logstash'
