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

# default kibana username for basic auth over ssl
# (see kibana_ssl.rb for how to set a password using node.run_state)
default['elkstack']['config']['kibana']['username'] = 'kibana'

# redirect HTTP to HTTPS?
default['elkstack']['config']['kibana']['redirect'] = true

# get on a much newer elasticsearch, override precomputed attributes
override['java']['jdk_version']            = '7' # newer ES requires
override['elasticsearch']['version']       = '1.3.2'
override['elasticsearch']['rpm_url']       = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.2.noarch.rpm'
override['elasticsearch']['rpm_sha']       = 'bd8c4041bf2d9ce68ff28f59926b5c793f96c478'
override['elasticsearch']['filename']      = "elasticsearch-#{node['elasticsearch']['version']}.tar.gz"
override['elasticsearch']['download_url']  = [node['elasticsearch']['host'], node['elasticsearch']['repository'], node['elasticsearch']['filename']].join('/')
