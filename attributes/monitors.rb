# setup attributes for monitoring
# process monitoring elastic search
default['elkstack']['cloud_monitoring']['process_elasticsearch']['disabled'] = false
default['elkstack']['cloud_monitoring']['process_elasticsearch']['period'] = '60'
default['elkstack']['cloud_monitoring']['process_elasticsearch']['timeout'] = '30'

# process monitoring logstash
default['elkstack']['cloud_monitoring']['process_logstash']['disabled'] = false
default['elkstack']['cloud_monitoring']['process_logstash']['period'] = '60'
default['elkstack']['cloud_monitoring']['process_logstash']['timeout'] = '30'

# process monitoring nginx
default['elkstack']['cloud_monitoring']['process_nginx']['disabled'] = false
default['elkstack']['cloud_monitoring']['process_nginx']['period'] = '60'
default['elkstack']['cloud_monitoring']['process_nginx']['timeout'] = '30'
