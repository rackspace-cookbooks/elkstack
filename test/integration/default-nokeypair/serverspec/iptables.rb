describe iptables do
  it { should have_rule('-P INPUT -p tcp --dport 80 -j ACCEPT') }
end
