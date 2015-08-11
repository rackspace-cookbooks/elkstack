# Attempt to supply an additional logstash configuration file like a real
# wrapper cookbook would -- see README.md.
node.set['elkstack']['config']['custom_logstash']['input_test']['cookbook'] = 'wrapper'
node.set['elkstack']['config']['custom_logstash']['input_test']['variables'] = { path: '/special_test_path' }
