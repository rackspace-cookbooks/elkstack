# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: base
#
# Copyright 2014, Rackspace
#
include_recipe 'build-essential'
include_recipe 'chef-sugar'

# we can no longer do: include_recipe 'python'
# because it makes broken pip calls before we can
# upgrade setuptools and pip, so we call the three
# recipes there-in (package, pip, virtualenv)
include_recipe "python::#{node['python']['install_method']}"

# for centos on rackspace cloud, due to:
# https://github.com/poise/python/issues/100#issuecomment-52047976
# https://github.com/poise/python/pull/112
# http://stackoverflow.com/questions/11425106/python-pip-install-fails-invalid-command-egg-info/25288078#25288078
case platform_family?
when 'rhel'
  commands = ['pip install -U setuptools', 'pip install -U setuptools', 'pip install -U pip']
  commands.each do |cmd|
    execute cmd # would love to guard this w/ pip versions, but at compile time, pip isn't installed
  end
end

# now this is safe, came from the python::default recipe
include_recipe "python::virtualenv"

# for long cloud server names :(
node.set['nginx']['server_names_hash_bucket_size'] = 128

# elasticsearch init scripts require ruby -- whee!
# maybe we'll do something different eventually, since it's only using ruby for
# parsing JSON -- we could do that with python which already have.
package 'ruby' do
  action :install
end
