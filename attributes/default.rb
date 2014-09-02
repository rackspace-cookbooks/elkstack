# send log lines to localhost only
default['rsyslog']['server_ip'] = '127.0.0.1'
default['rsyslog']['port'] = '5959'

# default to not running the cluster search recipe
default['elkstack']['config']['cluster'] = false

# default to include iptables rules
default['elkstack']['iptables']['enabled'] = 'true'

# default vhost stuff and SSL cert/key name
default['elkstack']['config']['site_name'] = 'kibana'

# attempt to use performance cloud data disk
default['elkstack']['config']['data_disk']['disk_config_type'] = false
