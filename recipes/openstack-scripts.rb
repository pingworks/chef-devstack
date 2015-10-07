cookbook_file 'restart-stack.sh' do
  path '/home/ubuntu/devstack/restart-stack.sh'
  owner 'ubuntu'
  group 'ubuntu'
  mode '755'
end
