# Iptables
describe iptables, if: iptables? do
  it { should have_rule('-A INPUT -p tcp -m tcp -m multiport --dports 5959 -m comment --comment "allow syslog entries inbound" -j ACCEPT') }
  it { should have_rule('-A INPUT -p tcp -m tcp -m multiport --dports 5960 -m comment --comment "allow lumberjack entries inbound" -j ACCEPT') }
  it { should have_rule('-A INPUT -p tcp -m tcp -m multiport --dports 5961 -m comment --comment "allow tcp entries inbound" -j ACCEPT') }
  it { should have_rule('-A INPUT -p tcp -m tcp -m multiport --dports 443 -m comment --comment "allow nginx SSL entries inbound" -j ACCEPT') }
  it { should have_rule('-A INPUT -p tcp -m tcp -m multiport --dports 80 -m comment --comment "allow nginx entries inbound" -j ACCEPT') }
  it { should have_rule('-A INPUT -p udp -m multiport --dports 5962 -m comment --comment "allow udp entries inbound" -j ACCEPT') }
  it { should have_rule('-A INPUT -s 1.2.3.4/32 -p tcp -m tcp -m multiport --dports 9300 -m comment --comment "allow ES host 1.2.3.4 to connect" -j ACCEPT') }
  it { should have_rule('-A INPUT -s 1.2.3.5/32 -p tcp -m tcp -m multiport --dports 9300 -m comment --comment "allow ES host 1.2.3.5 to connect" -j ACCEPT') }
  it { should have_rule('-A INPUT -i lo -m comment --comment "open_loopback" -j ACCEPT') }
end
