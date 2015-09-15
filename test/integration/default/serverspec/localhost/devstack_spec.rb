require_relative '../spec_helper'

describe file('/etc/nova/rootwrap.d/docker.filters') do
  it { should exist }
end

[
  'glance-registry',
  'glance-api',
  'nova-api',
  'nova-conductor',
  'nova-cert',
  'nova-scheduler',
  'nova-novncproxy',
  'nova-compute',
  'cinder-api',
  'cinder-scheduler',
  'cinder-volume',
  'python /usr/local/bin/neutron-server',
  'python /usr/local/bin/neutron-openvswitch-agent',
  'python /usr/local/bin/neutron-dhcp-agent',
  'python /usr/local/bin/neutron-l3-agent',
  'python /usr/local/bin/neutron-metadata-agent',
  'neutron-rootwrap-daemon',
  'neutron-ns-metadata-proxy'
].each do |proc|
  describe process(proc) do
    it { should be_running }
  end
end
