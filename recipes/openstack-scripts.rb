cookbook_file 'openstack.sh' do
  path '/home/ubuntu/openstack.sh'
  owner 'ubuntu'
  group 'ubuntu'
  mode '755'
end

cookbook_file 'boot-docker-instance.sh' do
  path '/home/ubuntu/boot-docker-instance.sh'
  owner 'ubuntu'
  group 'ubuntu'
  mode '755'
end

cookbook_file 'restart-stack.sh' do
  path '/home/ubuntu/devstack/restart-stack.sh'
  owner 'ubuntu'
  group 'ubuntu'
  mode '755'
end
