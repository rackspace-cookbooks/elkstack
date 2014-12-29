source "https://api.berkshelf.com"

metadata

cookbook 'kibana', git: 'git@github.com:lusis/chef-kibana.git', branch: 'v1.3.2'

# until https://github.com/elasticsearch/cookbook-elasticsearch/pull/230
cookbook 'elasticsearch', '~> 0.3', git:'git@github.com:racker/cookbook-elasticsearch.git'
# until https://github.com/lusis/chef-logstash/pull/336
cookbook 'logstash', git:'git@github.com:racker/chef-logstash.git'

# until https://github.com/poise/python/pull/120
cookbook 'python', git: 'git@github.com:racker/python.git'

cookbook 'rackspace_iptables', git: 'git@github.com:rackspace-cookbooks/rackspace_iptables.git'
cookbook 'rackspacecloud', git: 'git@github.com:rackspace-cookbooks/rackspacecloud.git'
cookbook 'rackspace_gluster', git: 'git@github.com:rackspace-cookbooks/rackspace_gluster.git'
cookbook 'rackops_rolebook', git: 'git@github.com:rackops/rackops_rolebook.git'

# not published
cookbook 'rackspace_cloudbackup', git:'git@github.com:rackspace-cookbooks/rackspace_cloudbackup.git'

group :integration do
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end

# until https://github.com/opscode-cookbooks/openssl/pull/11
cookbook 'openssl', git: 'git@github.com:racker/openssl.git'
