# 6.0.2
- stdout logstash config is now optional. Moved from hardcode to attribute.

# 6.0.1
- Fix for github issue #153. Lumberjack certificate placement not matching logstash agent input.

# 6.0.0

- Remove dependencies on stack_commons and platformstack.
  * Platformstack attributes are not supported anymore
  * ACL(iptables) are disabled by default
  * `node['elkstack']['config']['iptables']` has been replaced by `node['elkstack']['config']['iptables']['enabled']` for concistency
  * `node['elkstack']['config']['cloud_monitoring']['enabled']` should be used to enabled/disabled cloud monitoring
  * `node['elkstack']['cloud_monitoring'][CHECK]['alarm']` is now a flag, `node['elkstack']['cloud_monitoring'][CHECK]['alarm_criteria']` should be used to configure the alarm itself.
  * `node['elkstack']['cloud_monitoring'][CHECK]['period|timeout']` expects a FIXNUM

# 5.0.2

- Make elkstack more chef-solo friendly. We now check for solo before doing includes of elasticsearch::search_discovery, as well as better error checking on empty values when search has not been used, RE: #144.

# 5.0.1

- Move default lumberjack certs/keys to /etc from /opt/logstash, RE: #145.

# 5.0.0

- Remove the kibana.yml Kibana 4 workaround, now that kibana works again out of the box.
- Stop shipping Java wrappers. You must include `java::default` or get Java some other way, fixes #138.
- Clean up Berksfile. Many dependencies have since been fixed and/or released to Supermarket.
- Move back to logstash-forwarder pkg repos and removes golang deps. Fixes #139.
- Stop making a distinction between a cluster install vs. a single all-in-one install without any agent, fixes #135.
- Merge default and cluster and single recipes. Default is now a clustered elkstack.
- Tags and search/discovery all operate off 'elkstack' tag. There is no more 'elkstack_cluster' tag.
- Fixed some of the rspec/chefspec unit tests as well.
- The lumberjack protocol will no longer be the default for Logstash to communicate, due to hosted chef changes and golang runtime SSL changes (fixes #56, #14).
- Don't test the lumberjack protocol with the server install by default, removes lumberjack test suite in .kitchen.yml
- Default to tcp/udp for communication between logstash instances, added flag:
     `node['elkstack']['config']['agent_protocol'] = 'tcp_udp' # could also be lumberjack`
- Don't try to load lumberjack secrets by default for agent, don't fail if they aren't present (rename recipes/_secrets.rb -> recipes/_lumberjack_secrets.rb)
- Remove tests for lumberjack.key/crt now from default test suites, remove extra data bags with lumberjack keypairs

# 4.2.3

- Update kibana configuration file to support more kibana 4 parameter names
- Allow lumberjack functionality to be disabled
- Replace git:// with https:// to get logstash_forwarder

# 4.2.2

- Bump Elasticsearch to 1.4.4
- Update kibana configuration file to support more kibana 4 parameter names
- Disable Kibana 4 workarounds

# 4.2.1

Miscellaneous fixes

- Array for logstash configs needed a `default_unless`
- Go ahead and add a restart of the logstash agent before testing, to avoid CI timing weirdness

# 4.2.0

Workarounds and more support for Kibana 4

- Use 'kibana' as basic auth password for kibana, in test-kitchen
- Update to latest Elasticsearch (1.3.4 to 1.4.3) as Kibana 4 requires 1.4.x or greater (fixes #108)
- Enable dynamic scripting in Elasticsearch by default, as Kibana 4 requires it
- Add `kibana4_workarounds` recipe which deploys a working Kibana 4 configuration file (fixes #103)
- Add `node['elkstack']['kibana4_workaround']` that is enabled by by default, guards execution of recipe kibana4_workarounds
- Tests for elasticsearch health now drop replicas first, as kibana 4 seems to create an immediately orphaned one on a single node
- Remove 'no keypair' test for servers and agents in integration suites, add unit tests for the same

# 4.1.0

- Kibana password can now be a node attribute or run_state entry, is now respected (#99)
- Add missing runit dependency (#107)
- More workarounds and fixes for kibana 4 (#104)
- Change logstash forwarder to be installed from Git since packages were removed (#109)
- Update to newer upstream logstash cookbook to get fix for https://github.com/lusis/chef-logstash/issues/387 (#111)

# 4.0.0

- Use the latest lusis/chef-kibana cookbook, now installs Kibana 4
- Server name now defaults to `node['fqdn']`
- Depend on kibana_lwrp from Supermarket now, no more Berksfile entries

# 3.2.7

- Unpin and go back to chef 12
- Fix python builds on centos with setuptools manual run

# 3.2.6

- Fixed xmx and xms error in agent

# 3.2.5

- Bump for dev. Update poor comment.

# 3.2.4

- Ensure to pass the instance name to any custom templates, to be sure they end up in the correct directory

# 3.2.3

- Exit the agent recipe if no servers are found, don't try to proceed
- Add warnings about what the discovery logic is doing for the agent
- Don't search for server/cluster nodes on chef-solo, allow overrides
- Fixup tests to handle the chef-solo case but beef up check logic for fall through

# 3.2.2

- Add newrelic user to system, so agent will start.
- Cleanup attributes & recipe for backup based on testing, ES plugin changes
- Fix bug in unencrypted data bag access

# 3.2.1

- Fix a bug where the agent recipe was not installing custom configuration files with the right instance name (was using 'default' instead of 'agent'). Added a test fixture/wrapper cookbook in order to verify the correct behavior.

- Gave existing agent serverspec tests some easier to read description groups, to help read output easier.

# 3.2.0

- Allow wrappers and other cookbooks to supply additional logstash_config template files.

# 3.1.4

- Don't just raise an error, actually disable backups when cloud account credentials aren't present

# 3.1.3

- Clean up attributes so they don't error out when no cloud account is found

# 3.1.2

- Adds support for backups via snapshot API

# 3.1.1

- Update to latest Elasticsearch (v1.3.4)

# 3.1.0

- Remove attribute for additional templates. You should now call `logstash_` LWRPs directly to get this functionality back.
- Remove automatic inclusion of `platformstack` cookbooks. These should be called by a downstream wrapper.
- Better documentation for java requirement, Berkshelf requirements, and keypair requirements for Lumberjack.

# 3.0.2

- Check logstash base and error nicely if `node['logstash']['instance_default']['basedir']` isn't availablea

# 3.0.1

- Cleanup logging flags for agent

# 2.1.3

- Add attribute for additional templates to populate when this cookbook configures a logstash agent
- Correct platformstack/logging-enabled check to be more accurate
- Move lumberjack back to using JSON for exchanging data

# 2.1.2

- Fix an upstream logstash cookbook issue, contribute it back upstream ([#360](https://github.com/lusis/chef-logstash/pull/360)). Once that is merged, we can go back to upstream.
- Move agent attributes out more, to be their own explicit settings.

# 2.1.1

- Split out agent attributes into new attribute file.
- Clamp down agent memory usage from 256M to 10% of system at most.
- Fix logstash version typo, 1.4.1 vs. 1.4.2.

# 2.1.0

- Bump elasticsearch to version 1.3.3. This should improve memory consumption and has a host of other bug fixes. See [release notes](http://www.elasticsearch.org/blog/elasticsearch-1-3-3-released/).

# 2.0.1

- Add log warning for when we are automatically generating lumberjack keypairs
- Updates to README about memory consumption and how to optimize it
- Moved variables around in agent to make intent more clear (no logic changes)

# 2.0.0

- Add a `forwarder.rb` recipe that installs [logstash-forwarder](https://github.com/elastic/logstash-forwarder) as an alternative to logstash as an agent, including unit and integration tests.
- Add additional tests for existing test-kitchen suites to ensure new lumberjack keypair is written to disk.
- Fix a chefspec test issue where tests were checking for something that didn't make sense, didn't pass.

# 1.1.0

- Add `chef_environment` fields to be shipped to central cluster
- Add ACL recipe for agents to open up to :9300 on the ELK cluster nodes
- Fix protocol from node to transport on logstash agents (to avoid needing more ACLs)

# 1.0.0

- Bump logstash to version 1.4.2.
- Added top-level `agent` recipe and test suite, intended for running logstash-agent on a regular server. Uses `elasticsearch::search_discovery` to find and list elk cluster nodes (can override this as well, see elasticsearch cookbook for how). Agent uses lumberjack protocol by default and requires a keypair before converging.
- Switch nodes to communicate using node protocol on `eslocal:9300` between logstash and elasticsearch on the same box.
- Write chefspec tests for default (server nodes) and agent to 100% coverage. Add `chef-sugar` to `Gemfile` to be able to converge with chefspec and fauxhai.
- Drop dependency on `logstash_stack` (didn't need to be there any longer, wasn't used).
- Nodes no longer forward directly to logstash on the remote side, they forward to a local logstash listening for syslog.
- Bugfix: `/etc/hosts` is now correctly populated for all classes of elkstack, not just multi-node.
- Bugfix: The `newrelic` plugin now monitors against eslocal, not localhost.


# 0.3.0

- Bumped default Elasticsearch version to 1.3.2. Java 7 is now required, and some tests had to be adjusted.
- Fix bug in username not being used in tests because it was wrong in /etc/nginx/htpassword.curl.
- Fix bug where port 443 was not open in iptables.

# 0.2.0

- Added the ability to disable redirects on kibana

# 0.1.3

- Sheppy Reno - Convert process monitors to platformstack

# 0.1.2

- Add more options for kibana username and password fields under basic auth over SSL on nginx.

# 0.1.1

- Seperate recipes per service, add searching and tests. Major workarounds for logstash cookbook.

# 0.1.0

- Initial release of elkstack
