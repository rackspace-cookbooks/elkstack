
describe package('nginx') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe process('nginx') do
  it { should be_running }
end

describe command('curl -s http://localhost:80') do
  its(:stdout) { should match(/301 Moved Permanently/) }
end

describe command('curl -sk https://localhost:443') do
  it { should return_exit_status 0 }
  its(:stdout) { should match(/401 Authorization Required/) }
end

describe command('cat /etc/nginx/htpassword.curl | curl -K - -sk https://localhost:443') do
  it { should return_exit_status 0 }
  its(:stdout) { should match(/You must enable javascript to use Kibana/) }
end
