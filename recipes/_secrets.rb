# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: secrets
#
# Copyright 2014, Rackspace
#

# if there's a data bag, get the contents out, shove them in node.run_state
lumberjack_data_bag = node['elkstack']['config']['lumberjack_data_bag']

# try an encrypted data bag first
lumberjack_secrets = nil
begin
  lumberjack_secrets = Chef::EncryptedDataBagItem.load(lumberjack_data_bag, 'secrets')
  lumberjack_secrets.to_hash # access it to force an error to be raised
rescue
  Chef::Log.warn("Could not find encrypted data bag item #{lumberjack_data_bag}/secrets")
  lumberjack_secrets = nil
end

# try an unencrypted databag next
if lumberjack_secrets.nil?
  begin
    lumberjack_secrets = Chef::DataBagItem.load(lumberjack_data_bag, 'secrets')
    lumberjack_secrets.to_hash
  rescue
    Chef::Log.warn("Could not find un-encrypted data bag item #{lumberjack_data_bag}/secrets")
    lumberjack_secrets = nil
  end
end

# generate our own keypair since we don't seem to have one
if lumberjack_secrets.nil?
  Chef::Log.warn("Generating a new lumberjack keypair and data bag item #{lumberjack_data_bag}/secrets")
  cert_file = "#{Chef::Config[:file_cache_path]}/lumberjack.crt"
  key_file = "#{Chef::Config[:file_cache_path]}/lumberjack.key"
  openssl_x509 cert_file do
    common_name 'elkstack'
    org 'elkstack'
    org_unit 'elkstack'
    country 'US'
    key_file key_file
    action :nothing
  end.run_action(:create) # do it at compilation

  ruby_block 'read generated keypair from disk' do
    block do
      key_file_contents = IO.read(key_file)
      cert_file_contents = IO.read(cert_file)
      node.run_state['lumberjack_decoded_key_tmp'] = Base64.encode64(key_file_contents).tr("\n", '')
      node.run_state['lumberjack_decoded_certificate_tmp'] = Base64.encode64(cert_file_contents).tr("\n", '')
    end
    action :nothing
  end.run_action(:run) # do it at compilation

  key_contents = node.run_state['lumberjack_decoded_key_tmp']
  certificate_contents = node.run_state['lumberjack_decoded_certificate_tmp']

  # try to create a data bag and put a random keypair in it next
  secrets = {
    'id' => 'secrets',
    'key' => key_contents,
    'certificate' => certificate_contents
  }

  # unencrypted data bag if we just need a shared secret for ourselves
  lumberjack_secrets_bag = Chef::DataBag.new
  lumberjack_secrets_bag.name(lumberjack_data_bag)
  lumberjack_secrets_bag.save

  lumberjack_secrets = Chef::DataBagItem.new
  lumberjack_secrets.data_bag(lumberjack_data_bag)
  lumberjack_secrets.raw_data = secrets
  lumberjack_secrets.save
end

# now try to use the data bag
if !lumberjack_secrets.nil? && lumberjack_secrets['key'] && lumberjack_secrets['certificate']
  node.run_state['lumberjack_decoded_key'] = Base64.decode64(lumberjack_secrets['key'])
  node.run_state['lumberjack_decoded_certificate'] = Base64.decode64(lumberjack_secrets['certificate'])
elsif !lumberjack_secrets.nil?
  fail 'Found a data bag for lumberjack secrets, but it was missing \'key\' and \'certificate\' data bag items'
elsif lumberjack_secrets.nil?
  fail 'Could not find an encrypted or unencrypted data bag to use as a lumberjack keypair, and could not generate a keypair either'
else
  fail 'Unable to complete lumberjack keypair configuration'
end

logstash_basedir = node.deep_fetch('logstash', 'instance_default', 'basedir')
attribute_name = "node['logstash']['instance_default']['basedir']"
err_msg = "#{attribute_name} was not set; please ensure you are using the racker/chef-logstash version until lusis/chef-logstash/pull/336 is merged"
fail err_msg unless logstash_basedir

# if we had overrode basedir value, we'd need to use the new value here too
file "#{logstash_basedir}/lumberjack.key" do
  content node.run_state['lumberjack_decoded_key']
  owner node['logstash']['instance_default']['user']
  group node['logstash']['instance_default']['group']
  mode '0600'
  not_if { node.run_state['lumberjack_decoded_key'].nil? }
end

# if we had overrode basedir value, we'd need to use the new value here too
file "#{logstash_basedir}/lumberjack.crt" do
  content node.run_state['lumberjack_decoded_certificate']
  owner node['logstash']['instance_default']['user']
  group node['logstash']['instance_default']['group']
  mode '0600'
  not_if { node.run_state['lumberjack_decoded_certificate'].nil? }
end
