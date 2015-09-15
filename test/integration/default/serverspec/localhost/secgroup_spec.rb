require_relative '../spec_helper'

describe command('/home/ubuntu/openstack.sh demo nova secgroup-list-rules default') do
  its(:stdout) { should match /icmp.*-1.*-1.*0.0.0.0\/0/ }
  its(:stdout) { should match /tcp.*22.*22.*0.0.0.0\/0/ }
  its(:stdout) { should match /tcp.*80.*80.*0.0.0.0\/0/ }
  its(:exit_status) { should eq 0 }
end
