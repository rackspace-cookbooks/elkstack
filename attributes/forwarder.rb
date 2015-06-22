default['logstash_forwarder']['version'] = '0.3.1'
default['logstash_forwarder']['config_file'] = '/etc/logstash-forwarder'
default['logstash_forwarder']['user'] = 'root'
default['logstash_forwarder']['group'] = 'root'

default['logstash_forwarder']['config']['network']['servers'] = []
default['logstash_forwarder']['config']['network']['timeout'] = 15

# we could glob for these patterns, e.g. "/var/log/*.log", but it picks up some of our non-syslog formatted stuff if we do
default['logstash_forwarder']['config']['files']['default'] = {
  'paths' => { '/var/log/messages' => true, # redhat
               '/var/log/secure' => true,
               '/var/log/maillog' => true,
               '/var/log/cron' => true,
               '/var/log/spooler' => true,
               '/var/log/boot.log' => true,

               '/var/log/auth' => true, # ubuntu
               '/var/log/syslog' => true,
               '/var/log/cron.log' => true,
               '/var/log/daemon.log' => true,
               '/var/log/kern.log' => true,
               '/var/log/lpr.log' => true,
               '/var/log/mail.log' => true,
               '/var/log/user.log' => true,
               '/var/log/ufw.log' => true },
  'fields' => { 'type' => 'syslog' }
}

default['logstash_forwarder']['config']['files']['rackspace-monitoring-agent'] = {
  'paths' => { '/var/log/rackspace-monitoring-agent.log' => true },
  'fields' => { 'type' => 'rackspace-monitoring-agent' }
}

default['logstash_forwarder']['config']['files']['nova-agent'] = {
  'paths' => { '/var/log/nova-agent.log' => true },
  'fields' => { 'type' => 'nova-agent' }
}

default['logstash_forwarder']['config']['files']['driveclient'] = {
  'paths' => { '/var/log/driveclient.log' => true },
  'fields' => { 'type' => 'driveclient' }
}

default['logstash_forwarder']['config']['files']['stdin'] = {
  'paths' => { '-' => true },
  'fields' => { 'type' => 'stdin' }
}
