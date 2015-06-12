# elkstack

Elasticsearch, Logstash, and Kibana stack. Due to the recommendations of the
community, we are not using the embedded elasticsearch functionality of logstash
at this point. This cookbook provides recipes for all three components, along
with wrapper recipes such as `single` or `cluster` to facilitate different use
cases.

This stack's design is intended for one or many standalone nodes, with a full
stack of elasticsearch, logstash, and kibana. The only difference between one
and many nodes is that elasticsearch is clustered together. Data dispatched to
Logstash on a particular node will use the local elasticsearch transport
interface to index those logs to the node (and thus, the cluster). HTTP traffic
dispatched to Kibana on port 80 on any node will also use the local
elasticsearch HTTP interface to fetch and manipulate data.

Please read the individual recipe summaries to understand what each recipe does,
as well as what each wrapper recipe is actually wrapping. As much as possible,
upstream attributes have been exposed/overriden for our needs.

## Things you should know

- This cookbook requires java. Because not everyone has the same desires for
java versions, concurrently installed versions, or particular vendor versions,
this cookbook simply assumes you have already satisfied this requirement. This
cookbook _does_ ship with default attributes to make the community cookbook use
Java 7 over the default of Java 6.

- You must update your Berksfile to use this cookbook. Due to the upstream
changes constantly occuring, you should consult the `Berksfile` in this cookbook
and use its sources for `kibana`, `logstash`, and `elasticsearch` cookbooks.
Eventually, as PRs get merged, this may no longer be a hard requirement. But the
hardest thing will be that kibana in supermarket is currently a different
actual cookbook.

- You should probably disable the nginx virtualhost that comes with the `kibana`
cookbook and create your own configuration, securing it as appropriate for your
own requirements. See the `kibana_web` LWRP documentation for more on what
attributes should be set to accomplish this.

- If you'd like to disable backups using cloud files, set
`node['elkstack']['config']['backups']['enabled'] = false` (it defaults to
true). If you'd like to override the backup schedule/behavior for ES, simply
disable the backup crontab entry by setting
`node['elkstack']['config']['backups']['cron']=false`. This cookbook will still
configure everything except the cronjob, and then you may create another one
with your own schedule using the `cron_d` LWRP.

- Please note that this cookbook does not restart elasticsearch automatically,
in order to avoid causing an outage of the cluster. It does restart nginx and
logstash, however. You will have to restart elasticsearch after the initial
bootstrap. You may also need to bounce logstash if it seems confused about
losing a connection to eleasticsearch (unusual, but happens).

- You may want to consider adjusting `node['elasticsearch']['discovery']['search_query']`
if you are sharing one cluster among multiple environments. Just put a chef
search in that attribute and this will use that search instead of one scoped to
chef environments.

- You may want to consider adjusting `node['elasticsearch']['allocated_memory']`
if you are seeing an initial convergence failure (see [#50](https://github.com/rackspace-cookbooks/elkstack/issues/50)).
The chef client has been known to take up to 500mb or more on initial
convergence. Combined with an initial allocation of 40% memory for ES, and 20%
for logstash, that only leaves about 40% for the OS and chef. On a 2gb server,
that ends up being 800mb for ES, about 400mb for logstash, leaving 800mb for
the OS and the initial chef client run. After the initial run, memory footprint
for the chef-client tends to be much, much lower, and ES is able to start.

- The agent and logstash recipes requires a pre-generated SSL key and
certificate due to the requirements of the lumberjack protocol. This cookbook
will consult `node['elkstack']['config']['lumberjack_data_bag']` in order to
locate and load a database that stores this key. It will first try an encrypted
data bag, and if that doesn't work, will try an unencrypted data bag of the same
name. If no data bag is found, it will autogenerate one and save it as an
encrypted data bag. This means you must already have a 'secret file' on the node
for an encryption key, as this is a require to use any encrypted data bags.
To generate a key of your own, use something like:
```
openssl req -x509 -newkey rsa:2048 -keyout lumberjack.key -out lumberjack.crt -nodes -days 1000
```
This key and certificate data should be placed in data bag with name
`node['elkstack']['config']['lumberjack_data_bag']` under `key` and
`certificate` keys, and base64 encoded into a single line string. You may also
supply these secrets with some other method and populate the appropriate
`node.run_state` values (see `_secrets.rb` for more details). Note that this is
not a PKI trust model, but an [explicit trust model](https://spaces.internet2.edu/display/InCFederation/Metadata+Trust+Models#MetadataTrustModels-ExplicitKeyTrustModel). You may also set the data bag key to false to disable lumberjack entirely.

There exists a make-lumberjack-key.sh to help you make this. For Go 1.3+, you may be required
by the standard libraries to create a SAN cert [as described here](https://github.com/elastic/logstash-forwarder/issues/221#issuecomment-48823952).

## [Changelog](CHANGELOG.md)

See CHANGELOG.md for additional information about changes to this stack over time.

## Supported Platforms

Ubuntu 12.04

Ubuntu 14.04

CentOS 6.5

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['logstash']['instance_name']</tt></td>
    <td>String</td>
    <td>Default logstash instance name</td>
    <td><tt>server</tt></td>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['discovery']['search_query']</tt></td>
    <td>String</td>
    <td>A query to search for and connect Elasticsearch to cluster nodes</td>
    <td>(see `attributes/elasticsearch.rb`)</td>
  </tr>
  <tr>
    <td><tt>['logstash_forwarder']['config']['files']</tt></td>
    <td>Hash</td>
    <td>See customizing the stack section below.</td>
    <td>Most logs in `/var/log`</td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['data_disk']['disk_config_type']</tt></td>
    <td>Boolean or String</td>
    <td>See customizing the stack section below.</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['agent']['enabled']</tt></td>
    <td>Boolean</td>
    <td>Enable/Disable agent functionality</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['cloud_monitoring']['enabled']</tt></td>
    <td>Boolean</td>
    <td>Enable/Disable cloud_monitoring functionality</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['iptables']['enabled']</tt></td>
    <td>Boolean</td>
    <td>Enable/Disable iptables functionality</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['site_name']</tt></td>
    <td>String</td>
    <td>Control the name of the self-signed SSL key and cert in /etc/nginx/ssl</td>
    <td><tt>kibana</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['kibana']['redirect']</tt></td>
    <td>Boolean</td>
    <td>Enable/Disable nginx redirect for kibana from port 80 to port 443</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>node.run_state['elkstack_kibana_username']</tt> and <tt>['elkstack']['config']['kibana']['username']</tt></td>
    <td>String</td>
    <td>Default username for basic auth for kibana, run_state used first</td>
    <td><tt>kibana</tt></td>
  </tr>
  <tr>
    <td><tt>node.run_state['elkstack_kibana_password']</tt></td>
    <td>String</td>
    <td>Password for basic auth for kibana</td>
    <td>random from <tt>Opscode::OpenSSL::Password</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['lumberjack_data_bag']</tt></td>
    <td>String</td>
    <td>Data bag name for lumberjack key and certificate</td>
    <td><tt>lumberjack</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['custom_logstash']['name']</tt></td>
    <td>Array of strings</td>
    <td>See `attributes/logstash.rb` for an explanation of how to use this attribute to populate additional logstash configuration file templates</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['elkstack']['config']['restart_logstash_service']</tt></td>
    <td>Boolean</td>
    <td>Restart logstash if we deploy a custom config file</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Customizing the stack

To override local storage for elasticsearch nodes (the stack will format and mount, as well as configure elasticsearch), set `['elkstack']['config']['data_disk']['disk_config_type']` to `custom` and provide each storage device and mount point in the following way:
```ruby
disk_config = {
  'file_system' => 'ext4',
  'mount_options' => 'rw,user',
  'mount_path' => '/usr/local/var/data/elasticsearch/disk1',
  'format_command' => 'mkfs -t ext4 ',
  'fs_check_command' => 'dumpe2fs'
}

node.override['elasticsearch']['data']['devices']['/dev/xvde1'] = disk_config
node.override['elasticsearch']['path']['data'] = disk_config['mount_path']
```

To add additional logstash configuration to this stack, simply add additional
templates in your wrapper cookbook. They should be placed in
`"#{@basedir}/#{@instance}/etc/conf.d"` (see the config provider in the logstash
cookbook). If you choose to use logstash-forwarder instead of the regular agent,
please see the hash structure in `attributes/forwarder.rb` for adding additional
files for the forwarder to watch and forward, `node['logstash_forwarder']['config']['files']`.

To override the nginx configuration, simply supply a new template and specify
your cookbook using `['kibana']['nginx']['template_cookbook']` and
`['kibana']['nginx']['template']`. You can also override just the password for
the reverse proxy using `node.run_state['elkstack_kibana_password']`.

To override anything else, set the appropriate node hash (`logstash`, `kibana`, or `elasticsearch`).

## Usage

### elkstack::default

A simple wrapper recipe that sets up Elasticsearch, Logstash, and Kibana. Also
configures an rsyslog sink into logstash on the local box. Everything except
Logstash and Kibana is locked down to listen only on localhost.

### elkstack::agent

A simple wrapper recipe that sets up a logstash agent on the local box. Also
configures an rsyslog sink into logstash on the local box.
You need `node['elkstack']['config']['agent']['enabled']` set to `true` if you want to use this recipe (default to true).

### elkstack::forwarder

A [go-based alternative](https://github.com/elastic/logstash-forwarder) to the normal
agent, configured simply to watch logs forward them directly on to the cluster. This
project is in heavy development, and is not publishing releases very often, so the
packaged versions may be quite old or buggy. As of the addition of the recipe, the
package was almost a year behind current development, but only because there also
had been no releases either.

### elkstack::elasticsearch

Leans on the upstream `elasticsearch/cookbook-elasticsearch` cookbook for much
of its work. We do override the default set of plugins to be installed, as well
as the amount of JVM heap. See `attributes/default.rb` for those settings.

This recipe also tags the node so that other nodes that run this recipe can
discover it, and configure Elasticsearch appropriately to join their cluster.
It uses a tag, the current chef environment, and the cluster name as the default
search criteria.

Most of this is configurable using the upstream Elasticsearch cookbook's
attributes, including the chef search itself. There is not an easy toggle to
turn off the search, however.
Enables iptables rules if `node['elkstack']['config']['iptables']['enabled']` is not `nil`.

### elkstack::logstash

Leans on the upstream `lusis/chef-logstash` cookbook for much
of its work. We do override the default set of plugins to be installed, as well
as the amount of JVM heap. See `attributes/default.rb` for those settings.

### elkstack::kibana

Leans on the upstream `lusis/chef-kibana` cookbook for most of its work. Sets up
an nginx site for kibana by default. By default, it also does not pass through
most of the http paths directly to elasticsearch (whitelist).

### elkstack::newrelic

Validates if there is a newrelic license set and based on that, see if the node
is tagged as 'elkstack' and creates a file with elasticsearch details. Installs
python, pip and setuptools packages in order to support newrelic_meetme_plugin

## elkstack::acl

Adds cluster node basic iptables rules and cluster iptables rules if appropriate attributes
are set.

## elkstack::agent_acl

Adds agent node basic iptables rules.

## elkstack::disk_setup

Look for `node['elkstack']['config']['data_disk']['disk_config_type']` to be truthy, and configure the upstream elasticsearch cookbook to format, mount, and use devices appropriately.

## elkstack::\*\_monitoring

These correspond with the recipes above, and just provide a way to pull out the
monitoring work to make the original recipes cleaner.

### Miscellaneous

The wrapper recipes are `single` and `cluster`. These change attributes and then
invoke `elasticsearch`, `logstash`, `kibana`, and `rsyslog`. Finally, there are
utility recipes like `java` and `newrelic` (not invoked otherwise), as well as
`acl` which is called by `_base` if `node['elkstack']['config']['iptables']['enabled']`.

## Contributing

See [CONTRIBUTING](https://github.com/AutomationSupport/elkstack/blob/master/CONTRIBUTING.md).

## Authors

Author:: Rackspace (devops-chef@rackspace.com)

## License
```
# Copyright 2014, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
```
