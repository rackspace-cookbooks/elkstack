# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: base
#
# Copyright 2014, Rackspace
#

# workaround for our cloud images, which have broken pip/setuptools:
#  http://stackoverflow.com/questions/11425106/python-pip-install-fails-invalid-command-egg-info
#  https://github.com/pypa/pip/issues/1117
#  https://bugs.archlinux.org/task/27206
#
if platform_family?("rhel")
  execute 'pip install -U setuptools'
  execute 'pip install -U setuptools' # yes, twice, according to links above
  execute 'pip install -U pip'        # was the only way it worked for me.
end

# for long cloud server names :(
node.set['nginx']['server_names_hash_bucket_size'] = 128
