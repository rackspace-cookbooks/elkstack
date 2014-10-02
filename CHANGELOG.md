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
