# setup attributes for monitoring

cmd = default['elkstack']['cloud_monitoring']

# process monitoring elastic search
cmd['process_elasticsearch']['disabled'] = false
cmd['process_elasticsearch']['period'] = '60'
cmd['process_elasticsearch']['timeout'] = '30'
cmd['process_elasticsearch']['alarm'] = false

# process monitoring nginx/kibana
cmd['process_nginx']['disabled'] = false
cmd['process_nginx']['period'] = '60'
cmd['process_nginx']['timeout'] = '30'
cmd['process_nginx']['alarm'] = false

# process monitoring logstash
cmd['process_logstash']['disabled'] = false
cmd['process_logstash']['period'] = '60'
cmd['process_logstash']['timeout'] = '30'
cmd['process_logstash']['alarm'] = false

# port monitor for eleastic search http
# this port is not usually publicly accessible, disable by default
cmd['port_9200']['disabled'] = true
cmd['port_9200']['period'] = '60'
cmd['port_9200']['timeout'] = '30'
cmd['port_9200']['alarm'] = false

# port monitor for eleastic search transport
# this port is not usually publicly accessible, disable by default
cmd['port_9300']['disabled'] = true
cmd['port_9300']['period'] = '60'
cmd['port_9300']['timeout'] = '30'
cmd['port_9300']['alarm'] = false

# port monitor for logstash
cmd['port_5959']['disabled'] = false
cmd['port_5959']['period'] = '60'
cmd['port_5959']['timeout'] = '30'
cmd['port_5959']['alarm'] = false

# port monitor for nginx/kibana http
cmd['port_80']['disabled'] = false
cmd['port_80']['period'] = '60'
cmd['port_80']['timeout'] = '30'
cmd['port_80']['alarm'] = false

# port monitor for nginx/kibana https
cmd['port_443']['disabled'] = false
cmd['port_443']['period'] = '60'
cmd['port_443']['timeout'] = '30'
cmd['port_443']['alarm'] = false

# elasticsearch_{check name}
cmd['elasticsearch_cluster-health']['disabled'] = false
cmd['elasticsearch_cluster-health']['period'] = '60'
cmd['elasticsearch_cluster-health']['timeout'] = '30'
cmd['elasticsearch_cluster-health']['alarm'] = false
