
node.run_state['elkstack_kibana_password'] = 'insecurepassword' # this will usually come from an encrypted data bag
node.default['elasticsearch']['network']['host'] = '0.0.0.0'
node.default['elkstack']['config']['agent_protocol'] = 'lumberjack'

include_recipe 'java'
include_recipe 'elkstack'
