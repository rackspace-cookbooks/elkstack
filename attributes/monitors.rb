# setup attributes for monitoring
# process monitoring elastic search
default['elkstack']['cloud_monitoring']['process_elasticsearch']['disabled'] = false
default['elkstack']['cloud_monitoring']['process_elasticsearch']['period'] = '60'
default['elkstack']['cloud_monitoring']['process_elasticsearch']['timeout'] = '30'

# process monitoring nginx/kibana
default['elkstack']['cloud_monitoring']['process_nginx']['disabled'] = false
default['elkstack']['cloud_monitoring']['process_nginx']['period'] = '60'
default['elkstack']['cloud_monitoring']['process_nginx']['timeout'] = '30'

# process monitoring logstash
default['elkstack']['cloud_monitoring']['process_logstash']['disabled'] = false
default['elkstack']['cloud_monitoring']['process_logstash']['period'] = '60'
default['elkstack']['cloud_monitoring']['process_logstash']['timeout'] = '30'

# port monitor for eleastic search http
# this port is not usually publicly accessible, disable by default
default['elkstack']['cloud_monitoring']['port_9200']['disabled'] = true
default['elkstack']['cloud_monitoring']['port_9200']['period'] = '60'
default['elkstack']['cloud_monitoring']['port_9200']['timeout'] = '30'

# port monitor for eleastic search transport
# this port is not usually publicly accessible, disable by default
default['elkstack']['cloud_monitoring']['port_9300']['disabled'] = true
default['elkstack']['cloud_monitoring']['port_9300']['period'] = '60'
default['elkstack']['cloud_monitoring']['port_9300']['timeout'] = '30'

# port monitor for logstash
default['elkstack']['cloud_monitoring']['port_5959']['disabled'] = false
default['elkstack']['cloud_monitoring']['port_5959']['period'] = '60'
default['elkstack']['cloud_monitoring']['port_5959']['timeout'] = '30'

# port monitor for nginx/kibana http
default['elkstack']['cloud_monitoring']['port_80']['disabled'] = false
default['elkstack']['cloud_monitoring']['port_80']['period'] = '60'
default['elkstack']['cloud_monitoring']['port_80']['timeout'] = '30'

# port monitor for nginx/kibana https
default['elkstack']['cloud_monitoring']['port_443']['disabled'] = false
default['elkstack']['cloud_monitoring']['port_443']['period'] = '60'
default['elkstack']['cloud_monitoring']['port_443']['timeout'] = '30'
