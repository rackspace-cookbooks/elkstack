# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch_backups
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

# For all supported settings on this connector, see this documentation:
# https://github.com/jlinn/elasticsearch-cloud-rackspace#cloud-files-repository

account = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.account')
missing_account = 'Cannot perform backups without node[\'rackspace\'][\'cloud_credentials\'][\'username\'] or node[\'elasticsearch\'][\'customconfig\'][\'rackspace.account\']'
fail(missing_account) if account.nil? || account.empty?

key = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.key')
missing_apikey = 'Cannot perform backups without node[\'rackspace\'][\'cloud_credentials\'][\'api_key\'] or node[\'elasticsearch\'][\'customconfig\'][\'rackspace.key\']'
fail(missing_apikey) if key.nil? || key.empty?

# cloud files container is created automatically by plugin, so define it in elasticsearch for the plugin
region = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.region')
container = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.container')
chunksize = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.chunk_size')
streams = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.concurrent_streams')
basepath = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.base_path')
compress = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.compress')
setup_snapshot_repo = {
  type: 'cloudFiles',
  settings: {
    container: container,
    region: region,
    chunk_size: chunksize,
    concurrent_streams: streams,
    base_path: basepath,
    compress: compress
  }
}
http_request 'create elasticsearch snapshot repository for backups' do
  url 'http://eslocal:9200/_snapshot/elkstack'
  message setup_snapshot_repo.to_json
  action :put
end

# now schedule the backup
