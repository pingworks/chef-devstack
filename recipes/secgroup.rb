
bash 'setup secgroup' do
  code <<-EOF
  source /home/ubuntu/devstack/openrc demo
  nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
  nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
  nova secgroup-add-rule default tcp 80 80 0.0.0.0/0
  EOF
  not_if '/home/ubuntu/openstack.sh demo nova secgroup-list-rules default | grep icmp'
end
