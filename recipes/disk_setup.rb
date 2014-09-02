#
# Cookbook Name:: elkstack
# Recipe:: disk_setup
#
# Copyright 2014, Rackspace, US Inc.
#
# All rights reserved - Do Not Redistribute
#
dtype = node.deep_fetch('elkstack', 'config', 'disk_config_type')

case dtype
when false
  # don't act when false
when nil
  # don't act when nil
when 'custom'
  # assume ['elasticsearch']['data']['devices'] is filled with devices and settings
  # assume ['elasticsearch']['path']['data'] will be populated with mount points
  include_recipe 'elasticsearch::data'
when 'performance_cloud'
  disk_config = {
    'file_system' => 'ext4',
    'mount_options' => 'rw,user',
    'mount_path' => '/usr/local/var/data/elasticsearch/disk1',
    'format_command' => 'mkfs -t ext4 ',
    'fs_check_command' => 'dumpe2fs'
  }

  node.override['elasticsearch']['data']['devices']['/dev/xvde1'] = disk_config
  node.override['elasticsearch']['path']['data'] = disk_config['mount_path']
  include_recipe 'elasticsearch::data'
end
