describe user('elasticsearch') do
  it { should exist }
  it { should belong_to_group 'elasticsearch' }
  it { should have_home_directory '/usr/local/elasticsearch' }
end

describe port(9200) do
  it { should be_listening }
end

describe port(9300) do
  it { should be_listening }
end

describe service('elasticsearch') do
  it { should be_running }
end

describe 'elasticsearch' do
  # test with curl here
  describe command('sleep 5 && curl localhost:9200/_cluster/health?pretty=1') do
    its(:stdout) { should match(/.*"status" : "green".*/) }
  end

  # can't use process() matcher because of two java processes
  describe command('ps aux | grep -v grep | grep -si org.elasticsearch.bootstrap.Elasticsearch') do
    its(:exit_status) { should eq 0 }
  end
end

describe file('/usr/local/etc/elasticsearch/elasticsearch.yml') do
  it { should contain('cluster.name: elasticsearch') }
  it { should contain('path.conf: /usr/local/etc/elasticsearch') }
  it { should contain('path.data: /usr/local/var/data/elasticsearch') }
  it { should contain('path.logs: /usr/local/var/log/elasticsearch') }
  it { should contain('network.host: 127.0.0.1') }
  it { should contain('http.port: 9200') }
  it { should contain('discovery.zen.minimum_master_nodes: 1') }
  it { should contain('discovery.zen.ping.multicast.enabled: false') }
  it { should contain('discovery.zen.ping.unicast.hosts: 1.2.3.4,1.2.3.5') }
end
