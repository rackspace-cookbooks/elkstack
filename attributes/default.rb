# the name for the logstash instance, affects initscript names and other things
default['elkstack']['config']['logstash']['instance_name'] = 'server'

# enable logging with logstash using ELK stack
default['elkstack']['config']['agent']['enabled'] = true

# the name for an agent logstash instance, affects initscript names and other things
default['elkstack']['config']['logstash']['agent_name'] = 'agent'

# attempt to use lumberjack protocol for java agents?
default['elkstack']['config']['agent_protocol'] = 'tcp_udp' # could also be lumberjack

# attempt to use performance cloud data disk
default['elkstack']['config']['data_disk']['disk_config_type'] = false

# enable elasticsearch backups?
default['elkstack']['config']['backups']['enabled'] = true

# setup a backup in cron.d?
default['elkstack']['config']['backups']['cron'] = true

# default to not include iptables rules
default['elkstack']['config']['iptables']['enabled'] = false

# default to not include rackspace monitoring
default['elkstack']['config']['cloud_monitoring']['enabled'] = false

# default vhost stuff and SSL cert/key name
default['elkstack']['config']['site_name'] = 'kibana'

# redirect HTTP to HTTPS?
default['elkstack']['config']['kibana']['redirect'] = true

# default kibana username for basic auth over ssl
# (see kibana_ssl.rb for how to set a password using node.run_state)
default['elkstack']['config']['kibana']['username'] = 'kibana'

# data bag for lumerjack certificate and key
default['elkstack']['config']['lumberjack_data_bag'] = 'lumberjack'

# should I restart logstash after applying a custom config file?
default['elkstack']['config']['restart_logstash_service'] = true
