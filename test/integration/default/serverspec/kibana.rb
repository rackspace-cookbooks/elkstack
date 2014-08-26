
describe package('nginx') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe process('nginx') do
  it { should be_running }
end

describe command('curl -s http://localhost:80') do
  it { should return_exit_status 0 }
  its(:stdout) { should match(/You must enable javascript to use Kibana/) }
end
