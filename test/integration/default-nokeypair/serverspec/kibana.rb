
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

# should be this by default (there's a setting to change it, but not in the tests)
describe command('curl -s http://localhost:80') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/301 Moved Permanently/) }
end

describe command('curl -sk https://localhost:443') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/401 Authorization Required/) }
end

describe command('cat /etc/nginx/htpassword.curl | curl -K - -sk https://localhost:443') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/KIBANA_COMMIT_SHA/) }
end
