# setup attributes for monitoring

cmd = default['elkstack']['cloud_monitoring']

# port monitor for eleastic search http
# this port is not usually publicly accessible, disable by default
cmd['port_9200']['disabled'] = true
cmd['port_9200']['period'] = 60
cmd['port_9200']['timeout'] = 30
cmd['port_9200']['alarm'] = false

# port monitor for eleastic search transport
# this port is not usually publicly accessible, disable by default
cmd['port_9300']['disabled'] = true
cmd['port_9300']['period'] = 60
cmd['port_9300']['timeout'] = 30
cmd['port_9300']['alarm'] = false

# port monitor for logstash
cmd['port_5959']['disabled'] = false
cmd['port_5959']['period'] = 60
cmd['port_5959']['timeout'] = 30
cmd['port_5959']['alarm'] = false

# port monitor for nginx/kibana http
cmd['port_80']['disabled'] = false
cmd['port_80']['period'] = 60
cmd['port_80']['timeout'] = 30
cmd['port_80']['alarm'] = false

# port monitor for nginx/kibana https
cmd['port_443']['disabled'] = false
cmd['port_443']['period'] = 60
cmd['port_443']['timeout'] = 30
cmd['port_443']['alarm'] = false

# elasticsearch_{check name}
cmd['elasticsearch_cluster-health']['disabled'] = false
cmd['elasticsearch_cluster-health']['period'] = 60
cmd['elasticsearch_cluster-health']['timeout'] = 30
cmd['elasticsearch_cluster-health']['alarm'] = false

# Cloud Monitoring for Processes
# Process Monitors
services = %w(
  elasticsearch
  logstash
  nginx
)

services.each do |service|
  chk = cmd[service]
  chk['cookbook'] = 'rackspace_monitoring'
  chk['label'] = "Process monitor for #{service}"
  chk['disabled'] = false
  chk['period'] = 60
  chk['timeout'] = 30
  chk['file_url'] = 'https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/process_mon.sh'
  chk['details']['file'] = "#{service}-monitor.sh"
  chk['details']['args'] = [service]
  chk['details']['timeout'] = 60
  # Platformstack wants the alarm hash
  # Can override this in the wrapper/role/env
  chk['alarm'] = false
end

# ElasticSearch Health Monitor
es_health = cmd['elasticsearch_health']
es_health['cookbook'] = 'rackspace_monitoring'
es_health['label'] = 'ElasticSearch Cluster Health Monitor'
es_health['disabled'] = false
es_health['period'] = 60
es_health['timeout'] = 30
es_health['file_url'] = 'https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/elasticsearch.py'
es_health['details']['file'] = 'elasticsearch.py'
es_health['details']['args'] = ['-H', 'http://eslocal:9200', '--cluster-health']
es_health['alarm'] = false
