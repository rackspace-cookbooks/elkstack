# for storing snapshots in cloud files for backup, elasticsearch cookbook requires
# attributes go in ['elasticsearch']['custom_config'] if it doesn't know about them

es_rackspace = default['elasticsearch']['custom_config']

# defaults / overall settings
es_rackspace['rackspace.account'] = node['rackspace'] && node['rackspace']['cloud_credentials'] && node['rackspace']['cloud_credentials']['username']
es_rackspace['rackspace.key'] = node['rackspace'] && node['rackspace']['cloud_credentials'] && node['rackspace']['cloud_credentials']['api_key']
es_rackspace['rackspace.enabled'] = es_rackspace['rackspace.account'] && es_rackspace['rackspace.key'] && 'true'
es_rackspace['rackspace.region'] = 'ORD' # region: The datacenter to be used. Defaults to ORD. Currently, only DFW, ORD, and IAD are supported.

# snapshot-repo specific settings

# container: The name of the Cloud Files container to be used. This is mandatory.
es_rackspace['repositories.cloudfiles.container'] = 'elkstack'

# base_path: Specifies the path within the container to store repository data. Defaults to the root of the container.
es_rackspace['repositories.cloudfiles.base_path'] = '/'

# concurrent_streams: Throttles the number of streams per node while performing a snapshot operation. Defaults to 5.
es_rackspace['repositories.cloudfiles.concurrent_streams'] = '5'

# chunk_size: Big files can be broken down into chunks during snapshotting if needed. The chunk size can be specified in bytes or by using size value notation, i.e. 1g, 10m, 5k.
es_rackspace['repositories.cloudfiles.chunk_size'] = '100m'

# compress: When set to true, metadata files are stored in compressed format. This setting doesn't affect index files which are already compressed by default. Defaults to false.
es_rackspace['repositories.cloudfiles.compress'] = false
