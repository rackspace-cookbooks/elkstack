# Attempt to supply an additional logstash configuration file like a real
# wrapper cookbook would -- see README.md.
node.set_unless['elkstack']['config']['custom_logstash']['name'] = []
node.set['elkstack']['config']['custom_logstash']['name'].push('wrapper')
node.set['elkstack']['config']['custom_logstash']['wrapper']['name'] = 'input_test'
node.set['elkstack']['config']['custom_logstash']['wrapper']['cookbook'] = 'wrapper'
node.set['elkstack']['config']['custom_logstash']['wrapper']['variables'] = { path: '/special_test_path' }
