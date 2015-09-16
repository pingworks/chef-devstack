
bash 'setup secgroup' do
  code <<-EOF
  source /home/ubuntu/devstack/openrc demo
  nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
  nova secgroup-add-rule default tcp 1 65535 0.0.0.0/0
  nova secgroup-add-rule default udp 1 65535 0.0.0.0/0
  EOF
  not_if '/home/ubuntu/openstack.sh demo nova secgroup-list-rules default | grep icmp'
end
