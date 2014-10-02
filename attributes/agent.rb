agent_name = node['elkstack']['config']['logstash']['agent_name']
agent = normal['logstash']['instance'][agent_name]

# restrict logstash to 10% of the box, starting at 256M
agent['xms'] = "#{(node['memory']['total'].to_i * 0.1).floor / 1024}M"
agent['xmx'] = '256M'
