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
  it 'should report status ok' do
    expect(command 'sleep 5 && curl localhost:9200/_status?pretty=1')
    .to return_stdout(/.*"ok" : true.*/)
  end

  # can't use process() matcher because of two java processes
  it 'should be running Elasticsearch main class' do
    expect(command 'ps aux | grep -v grep | grep -s org.elasticsearch.bootstrap.ElasticSearch')
    .to return_exit_status 0
  end
end
