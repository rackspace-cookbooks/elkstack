CONTRIBUTING
===========

# General
* The following document will serve as a guide on what and how to contribute to any stack within [AutomationSupport](http://github.com/AutomationSupport/).
* The cookbook name, attribute namespace and git repo should all be the same, and should be lower case with no punctuation
 * i.e. `tomcatstack`, `phpstack`
* The following items will not be supported in these stacks
 * Compiling from Source in recipes
 * Operating systems outside `ubuntu`,`debian`,`rhel`,`centos`
* We will default to Rackspace provided systems
 * i.e. for ntp, we will default to rackspace ntp servers and fall back to community ones  
* Berkshelf should update to point to github locations for any cookbook dependency
 * i.e `cookbook "rackspace_foo", github: "rackspace_cookbooks/rackspace_foo"`

# Testing
* test-kitchen 1.x support is required for all cookbooks. Please see [test-kitchen](https://github.com/opscode/test-kitchen) for more details.
* [Bundler](http://bundler.io/) will be used to run rake tasks and most other commands in the stack repository. This ensures consistent gems across developers and tests. Most commands can simply be prefixed with `bundle` for this to work.
* All commits should converge & pass all tests using the test suites defined in .kitchen.yml.
* All commits should be tested using `bundle exec rake style` and should pass foodcritic and rubocop rules.
* Added features should include additional tests. Pull requests without tests may be denied.
* Workflow: `Jenkins -> rake -> knife -> foodcritic -> chefspec -> kitchen -> Jenkins -> Thor (git tag)`
* Tests should be called and have any needed attributes set in a .kitchen.yml file with separate suites as appropriate. We will append our own .kitchen.local.yml during the jenkins run.
* Please review the .kitchen.yml included in this stack for what platforms are supported and required.
* CI will be performed via Jenkins at jenkins.rackops.org on any pull requests.

#Misc
## GIT Tags
* Version increases should have an accompanying git tag. Jenkins will be responsible for ensuring this is complete.

## Licensing
* All Cookbooks must be Apache 2.0 licensed. "# Copyright <year>, Rackspace" should be included in every recipe as well.
* Include a `LICENSE` file in the top level directory of the cookbook with the Apache 2.0 Official license
* Include a `License and Authors` section of the `README.md`. See example at [rackspace-user](https://github.com/rackspace-cookbooks/rackspace-user)
* If you've forked the cookbook from another repo, please add notes attributing the original work to that repo

## README.md / Documentation
* Please include a README.md file in the cookbook root directory.
* Please include Descriptions, Platform support, notes, notes on recipes, attributes, CONTRIBUTING and testing specifications.
* If the cookbook is a fork, please credit original cookbook authors.

## CHANGELOG.md
* Please include a `CHANGELOG.md` in the cookbook root directory
* Please include brief notes about your changes and your name in each pull request

## Gemfile
* standard Gemfile is [here](https://github.com/AutomationSupport/templatestack/blob/master/Gemfile)

## Rakefile
* standard Rakefile is [here](https://github.com/AutomationSupport/templatestack/blob/master/Rakefile)

## Thor
* Standard Thorfile is [here](https://github.com/AutomationSupport/templatestack/blob/master/Thorfile)

## Rubocop
* standard .rubocop.yml is [here](https://github.com/AutomationSupport/templatestack/blob/master/.rubocop.yml)
* Disabling cops in code is allowed where the style recommendation results in code which is more difficult to read, is messier than the original, or is otherwise arguable as an anti-pattern.  Disabled cops must have comments documenting why they are disabled and disable target code blocks, not a whole file.  See [the Rubocop docs](https://github.com/bbatsov/rubocop#disabling-cops-within-source-code) for details on in-code disables.

### Chefspec
* All Chefspec tests should be located in `spec` within the parent cookbook
* All in memory testing. Isolated, independent, atomic.
* LWRPs and libraries need additional unit tests

### Functional tests (test-kitchen)
* Tests should be handled as a directory under `/test/integration/$suitename`. This is defined [here](http://kitchen.ci/docs/getting-started/writing-test) whereby the $suitename matches the suite defined in .kitchen.yml

## Vagrantfile
* Not required but nice to have :)

# Code Review
* All code additions and pull requests are subject to the following:
    * Automated CI run must pass. Successes and Failure feedback will be provided in the pull request.
    * An admin must review the code prior to being merged

# Guidelines
* TODO: add notes regarding guidelines for advanced cookbooks (libraries, LWRPS, etc)

#Chef
## Attributes
* All Attribute hashes should be indexed with strings instead of symbols or using 'dot notation'
 * i.e. `node['rackspace_apt']['config']`, not `node[:rackspace_apt][:config]` and not `node.rackspace_apt.config`
* All Attributes namespace should match the cookbook name
 * i.e. `default['rackspace_user']`
* All Attributes that will be written a configuration file must fall under a ['config'] hash
 * i.e. `default['rackspace_apache']['config']`
* Attributes should default to the same ones as installed by the package or sane modifications.
* "data dirs" should be configurable for any service
 * i.e. for mysql `default['rackspace_mysql']['data_dir'] = "/var/lib/mysql"`

## Recipes
 * Copypasta - Anything being copied and pasted around between stack cookbooks
 should be brought up into a community cookbook. If a community cookbook is
 stale or otherwise untenable, a cookbook shall be released in
 rackspace-cookbooks that contains the minimal desired modifications. The long
 term goal will still be to get these eventually into the community, either
 through contributing back or maintaining the community cookbook.
 * monitors.rb - Standard rackspace cloud checks for this cookbook. These should not automatically be included by the cookbook and should only be available to be included.
 * This should populate the config hash `node['rackspace_cloudmonitoring']['monitors']`

##Templates

### Headers
Templates must contain a banner stating they are Chef managed and the name of the controlling cookbook. Here is the preferred banner:
```ruby
#
# CHEF MANAGED FILE: DO NOT EDIT
# Controlling Cookbook: <%=  @cookbook_name %>
#
```
And you need to pass the `cookbook_name` variable in your template delaration:
```ruby
template '/etc/ssh/sshd_config' do
  cookbook node['rackspace_contrib_example']['templates_cookbook']['config']
  source 'config.erb'
  variables (cookbook_name: cookbook_name)
end
```


For example, in a template using hash comments:

```ruby
#
# CHEF MANAGED FILE: DO NOT EDIT
# Generated by Chef for <%= node['hostname'] %>
# Controlling Cookbook: [ Cookbook Name ]
# Contact Rackspace DevOps Automation with questions
#
```

Or in an XML file:

```xml
<!-- CHEF MANAGED FILE: DO NOT EDIT
     Generated by Chef for <%= node['hostname'] %>
     Controlling Cookbook: [ Cookbook Name ]
     Contact Rackspace DevOps Automation with questions
-->  
```

Replace "[ Cookbook Name ]" with the name of the cookbook the template is in.


### Config Hashes
Templates should use configuration hashes as much as possible to allow adding of options to the config without needing to commit changes to the core cookbook.
The config hash must:
* Use the `node['cookbook']['config']` namespace
* Use an inner hash `node[cookbook]['config'][key]['value'] = value` instead of direct key:value pairs.

An example of a mongodb.conf template exclusively following this style would be:

```ruby
#
# CHEF MANAGED FILE: DO NOT EDIT
# Generated by Chef for <%= node['hostname'] %>
# Controlling Cookbook: rackspace_contributing_example
# Contact Rackspace DevOps Automation with questions
#

<%
# Generated using a config hash methodology
# Each setting is a key in the node['rackspace_contributing_example']['config']['mongodb.conf'] hash
#
# The key of the config hash is the option name.
#   The supported keys of the value are
#      'comment': An optional comment
#      'value': The value for the option

node['rackspace_contributing_example']['config']['mongodb.conf'].each do |key, value|
  if value.key?('comment')
-%>
# <%= key -%>: <%= value['comment'] %>
<% end -%>
<%= key -%> = <%= value['value'] %>
<% end -%>  
```

And the corresponding attributes/default.rb:

```ruby
# Attributes used in the mongodb.conf file
default['rackspace_contributing_example']['config']['mongodb.conf']['dbpath']['value']       = '/var/lib/mongodb'
default['rackspace_contributing_example']['config']['mongodb.conf']['logpath']['value']      = '/var/log/mongodb/mongodb.log'
default['rackspace_contributing_example']['config']['mongodb.conf']['logappend']['comment']  = 'Append to the logs by default.'
default['rackspace_contributing_example']['config']['mongodb.conf']['logappend']['value']    = true
default['rackspace_contributing_example']['config']['mongodb.conf']['auth']['value']         = true
default['rackspace_contributing_example']['config']['mongodb.conf']['keyFile']['value']      = '/var/lib/mongodb/mongodb.key'
```

As opposed to a basic key:value hash the inner hash is used to allow hooks for more complicated cookbooks.
This allows the adding of comments, weights, disable flags, etcetera.
Supporting the 'value' and 'comment' inner hash keys is strongly recommended.
Use of any other keys is left to the discretion of the author.

The following is a more complicated template that mixes explicit and hash options:

```ruby
#  
# CHEF MANAGED FILE: DO NOT EDIT
# Generated by Chef for <%= node['hostname'] %>
# Controlling Cookbook: rackspace_contributing_example
# Contact Rackspace DevOps Automation with questions
#

<%
# Generated using a config hash methodology
# Each setting is a key in the node['rackspace_contributing_example']['config']['thing.conf'] hash
#
# The key of the config hash is the option name.
#   The supported keys of the value are
#      'comment': An optional comment
#      'value': The value for the option

# Duplicate the hash so we can remove keys we explicitly call
# This is required to prevent modifying the main node data
# Unfortunately .dup and .clone don't work; .dup is a shallow copy and .clone trips the read-only protection
#  on the node class.  The node class has a to_hash method, but it is also a shallow copy.
# Manually copy the hashes we need via a simple recursive copier
# Be advised this example will mung up arrays.
def deep_copy_node(node_data)
  begin
    ret_val = {}
    node_data.each do |key, value|
      # Recurse to deep copy any iterables referenced
      ret_val[key] = deep_copy_node(value)
    end
    return ret_val
  rescue NoMethodError
    # This is thrown when the object doesn't support .each
    return node_data
  end
end
my_config_hash = deep_copy_node(node['rackspace_mysql']['config'])
-%>

# Explicitly use an option
SpecialArg1: <%= my_conf['SpecialArg1']['value'] -%>
<% my_conf.delete('SpecialArg1') # Delete the key from the hash -%>

# Explicitly use another option
SpecialArg2: <%= my_conf['SpecialArg2']['value'] -%>
<% my_conf.delete('SpecialArg2') # Delete the key from the hash -%>

# Explicitly use  a third option
SpecialArg3: <%= my_conf['SpecialArg3']['value'] -%>
<% my_conf.delete('SpecialArg3') # Delete the key from the hash -%>

#
# Dynamically added values
#

<%
# As we've deleted the used keys, we can now roll over the remaining keys as before:
my_conf.each do |key, value|
  if value.key?('comment')
-%>
# <%= key -%>: <%= value['comment'] %>
<% end -%>
<%= key -%> = <%= value['value'] %>
<% end -%>
```

That is a simplified example, ideally the explicitly used keys would still read comments and handle other options implemented.
It is also possible, for templates where the author objects to dynamic options, to use the method above but comment out the option with a big warning, or even call fail to abort the run.
See [rackspace_mysql my.cnf.erb](https://github.com/rackspace-cookbooks/rackspace_mysql/blob/master/templates/default/my.cnf.erb) for a complete example including helper methods wich parse and handle the inner hash.

See [rackspace-cookbooks/rackspace_sysctl](https://github.com/rackspace-cookbooks/rackspace_sysctl) for a direct example usage or [rackspace-cookbooks/rackspace_iptables](https://github.com/rackspace-cookbooks/rackspace_iptables) for a more abstracted use.

### Template Provider Calls
Template provider calls should always include the `cookbook` attribute as to allow for easily overriding from a wrapper cookbooks. The default should always be the cookbook itself.

i.e. in a recipe:

```ruby
template "/etc/sudoers" do
  cookbook node['rackspace_sudo']['templates_cookbook']['sudoers']
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
end
```

i.e in attributes:

```ruby
   default['rackspace_sudo']['templates_cookbook']['sudoers'] = "rackspace_sudo"
```

## metadata.rb
* All dependencies should be listed with the pessimistic operation ("~> ") to the minor version
 * i.e. depends "rackspace_apt", "~> 1.2"
* Version changes are defined as follows for `version 'x.y.z'`:
 * `x:` Major changes that break functionality and may not be backwards compatible with previous versions.
 * `y:` Functionality addons and non-breaking changes
 * `z:` Commits, patches, bugfixes, etc.
