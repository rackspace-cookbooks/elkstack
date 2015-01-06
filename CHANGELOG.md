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

- Add a `forwarder.rb` recipe that installs [logstash-forwarder](https://github.com/elasticsearch/logstash-forwarder) as an alternative to logstash as an agent, including unit and integration tests.
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
