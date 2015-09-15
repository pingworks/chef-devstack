bash 'checkout designate' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu'
  code <<-EOF
  git clone -b stable/kilo #{node['devstack']['gitmirror']}/openstack/designate.git
  EOF
  not_if 'test -d /home/ubuntu/designate/.git'
end

bash 'install designate' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu/devstack'
  code <<-EOF
  ../designate/contrib/devstack/install.sh
  EOF
  not_if 'test -L /home/ubuntu/devstack/extras.d/70-designate.sh'
end
