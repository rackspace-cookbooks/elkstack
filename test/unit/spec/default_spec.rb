# Encoding: utf-8

require_relative 'spec_helper'

describe 'elkstack::cluster' do
  let(:chef_run) do
    stub_resources
    ChefSpec::SoloRunner.new(platform: 'redhat', version: '6.5') do |node|
      node.set['cpu']['total'] = 8
      node.set['memory']['total'] = 4096
      node.set['public_info']['remote_ip'] = '127.0.0.1'
      node.set['chef_environment'] = '_default' # be a dummy env for htpasswd.curl
      node.set['rackspace']['cloud_credentials']['username'] = 'joe-test'
      node.set['rackspace']['cloud_credentials']['api_key'] = '123abc'
      node.set['filesystem'] = []
    end.converge(described_recipe, 'platformstack::monitors')
    # converge WITH platformstack so we can test our templates are created
  end

  it 'installs ruby' do
    expect(chef_run).to install_package('ruby')
  end

  it 'includes the _server, elasticsearch, logstash, and kibana recipes' do
    expect(chef_run).to include_recipe('elkstack::_server')
    expect(chef_run).to include_recipe('elkstack::elasticsearch')
    expect(chef_run).to include_recipe('elkstack::logstash')
    expect(chef_run).to include_recipe('elkstack::kibana')
    expect(chef_run).to include_recipe('rsyslog::client')
  end

  it 'installs and configures elasticsearch' do
    expect(chef_run).to enable_service('elasticsearch')
    expect(chef_run).to start_service('elasticsearch')

    # it seems like this should exist, but it's done inside ruby lwrps, so maybe we can't test it
    # expect(chef_run).to append_if_no_line('make sure a line is in /etc/hosts')

    expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-service-tcp-elasticsearch-9200.yaml')
    expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-service-tcp-elasticsearch-9300.yaml')
  end

  it 'monitors nginx' do
    expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-service-tcp-monitor-nginx-80.yaml')
    expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-service-tcp-monitor-nginx-443.yaml')
  end

  it 'installs and configures logstash' do
    expect(chef_run).to create_directory('/opt/logstash')

    # service (enable includes start in LWRP in logstash cookbook)
    expect(chef_run).to enable_logstash_service('server')

    # instance lwrp
    expect(chef_run).to create_logstash_instance('server')

    # config lwrp
    expect(chef_run).to create_logstash_config('server')

    expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-service-tcp-monitor-logstash-5959.yaml')

    # we may eventually want some patterns defined
    # expect(chef_run).to create_logstash_pattern('server')
  end

  it 'creates htpassword and htpassword.curl to protect kibana' do
    expect(chef_run).to create_directory('/etc/nginx/ssl')
    expect(chef_run).to add_htpasswd('/etc/nginx/htpassword')
    expect(chef_run).to create_file_if_missing('/etc/nginx/htpassword.curl')
  end

  it 'installs and configures kibana and nginx' do
    expect(chef_run).to delete_file('/etc/nginx/conf.d/default.conf') # only on RHEL

    # we put an 'action :nothing' on this one
    expect(chef_run.service('nginx')).to do_nothing

    expect(chef_run).to create_kibana_install('kibana')
    expect(chef_run).to create_template('/opt/kibana/current/config/kibana.yml')
    expect(chef_run).to create_kibana_web('kibana')
    expect(chef_run).to create_kibana_user('kibana')
    expect(chef_run).to create_openssl_x509('/etc/nginx/ssl/kibana.pem')
    expect(chef_run).to enable_runit_service('kibana')
  end

  it 'creates a backup repo and crontab entry' do
    expect(chef_run).to put_http_request('create elasticsearch snapshot repository for backups')
    expect(chef_run).to create_cron_d('elkstack-elasticsearch-backup')
  end
end
