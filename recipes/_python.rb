# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: _python
#
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

# Upgrade pip once and setuptools twice to ensure pip works -- (the three
# include_recipes below map to python::default, with our install interjected
# into the middle)

include_recipe 'chef-sugar'

include_recipe "python::#{node['python']['install_method']}"
include_recipe 'python::pip'

bash 'manually upgrade setuptools' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  easy_install --upgrade setuptools
  EOH
  only_if { rhel? }
end

include_recipe 'python::virtualenv'
