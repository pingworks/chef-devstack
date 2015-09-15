require_relative '../spec_helper'

describe command('cat /proc/sys/net/ipv4/ip_forward') do
  its(:stdout) { should match /^1$/ }
  its(:exit_status) { should eq 0 }
end

describe command('cat /proc/sys/net/ipv4/conf/eth0/proxy_arp') do
  its(:stdout) { should match /^1$/ }
  its(:exit_status) { should eq 0 }
end

#describe command('iptables -L -t nat') do
#  its(:stdout) { should match /^1$/ }
#  its(:exit_status) { should eq 0 }
#end
