
describe package('nginx') do
  it { should be_installed }
end

describe port(443) do
  it { should be_listening }
end

describe process('nginx') do
  it { should be_running }
end

describe command('curl -sk https://$(/sbin/ifconfig eth0 | grep \'inet addr:\' | cut -d: -f2 | awk \'{ print $1}\'):443') do
  it { should return_exit_status 0 }
  its(:stdout) { should match(/401 Authorization Required/) }
end
