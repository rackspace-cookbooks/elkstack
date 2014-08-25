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

## [Changelog](CHANGELOG.md)

See CHANGELOG.md for additional information about changes to this stack over time.

## Supported Platforms

Ubuntu 12.04

CentOS 6.5

## Attributes

This stack does not offer any specific attributes beyond the upstream cookbook attributes, many of which it overrides.
<!--
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['elkstack']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>
-->
## Usage

### elkstack::default

Default recipe, does not do anything.

### elkstack::java

Wrapper for a java recipe. This is not included on the run list normally, so if
you don't already, you must include this recipe or get another JVM installed
before including anything else in this cookbook.

### elkstack::kibana

Leans on the upstream `lusis/chef-kibana` cookbook for most of its work. Sets up
an nginx site for kibana by default. By default, it also does not pass through
most of the http paths directly to elasticsearch (whitelist).

### elkstack::elasticsearch

Leans on the upstream `elasticsearch/cookbook-elasticsearch` cookbook for much
of its work. We do override the default set of plugins to be installed, as well
as the amount of JVM heap. See `attributes/default.rb` for those settings.

### elkstack::logstash

Leans on the upstream `lusis/chef-logstash` cookbook for much
of its work. We do override the default set of plugins to be installed, as well
as the amount of JVM heap. See `attributes/default.rb` for those settings.

### elkstack::rsyslog

Leans on the upstream `opscode-cookbooks/rsyslog` cookbook for most of its work.
We do add the logstash user to the rsyslogd's group before we call
`rsyslog::client` to configure the node's rsyslogd itself to send to logstash.

### Miscellaneous

You may do `include_recipe 'rsyslog::client'` if you'd like a local rsyslog that
sends to the local logstash instance. The stack has already been configured with
attributes for this use case. See `attributes/default.rb` for those settings.


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
