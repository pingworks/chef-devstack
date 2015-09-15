require_relative '../spec_helper'

describe command('ovs-vsctl list-ports br-ex') do
  its(:stdout) { should match /eth0/ }
  its(:exit_status) { should eq 0 }
end

describe command('ip addr list dev br-ex') do
  its(:stdout) { should match /inet 172.24.4.1\/24/ }
  its(:stdout) { should match /inet 10.0.2.15\/24/ }
  its(:exit_status) { should eq 0 }
end

describe command('ip route') do
  its(:stdout) { should match /^default via 10.0.2.2/ }
end
