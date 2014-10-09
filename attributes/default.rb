# the name for the logstash instance, affects initscript names and other things
default['elkstack']['config']['logstash']['instance_name'] = 'server'

# the name for an agent logstash instance, affects initscript names and other things
default['elkstack']['config']['logstash']['agent_name'] = 'agent'

# default to not running the cluster search recipe
default['elkstack']['config']['cluster'] = false

# attempt to use performance cloud data disk
default['elkstack']['config']['data_disk']['disk_config_type'] = false

# default to include iptables rules
default['elkstack']['iptables']['enabled'] = 'true'

# default vhost stuff and SSL cert/key name
default['elkstack']['config']['site_name'] = 'kibana'

# redirect HTTP to HTTPS?
default['elkstack']['config']['kibana']['redirect'] = true

# default kibana username for basic auth over ssl
# (see kibana_ssl.rb for how to set a password using node.run_state)
default['elkstack']['config']['kibana']['username'] = 'kibana'

# data bag for lumerjack certificate and key
default['elkstack']['config']['lumberjack_data_bag'] = 'lumberjack'
