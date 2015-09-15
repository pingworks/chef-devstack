
# deps for devstack installation
package 'git'
package 'python-pip'
package 'python-dev'

bash 'checkout nova-docker' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu'
  code <<-EOF
  export HOME=/home/ubuntu
  git clone -b stable/kilo #{node['devstack']['gitmirror']}/stackforge/nova-docker.git
  # Cherry pick the mtu fix from master
  EOF
  not_if 'test -d /home/ubuntu/nova-docker/.git'
end

cookbook_file 'nova-docker-fix1.patch' do
  path '/home/ubuntu/nova-docker/nova-docker-fix1.patch'
  owner 'root'
  group 'root'
  mode '644'
end

bash 'patch nova-docker' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu/nova-docker'
  code <<-EOF
  export HOME=/home/ubuntu
  git config user.email "christoph.lukas@gmx.net"
  git config user.name "Christoph Lukas"
  git cherry-pick 3b3a0c744de288ef3477c6b2940e6308357777f2
  git am < nova-docker-fix1.patch
  EOF
  not_if 'cd /home/ubuntu/nova-docker/ && git log -2 --oneline | grep "vif: Setup MTU on if_remote_name when attach"'
end


bash 'install nova-docker' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu/nova-docker'
  code <<-EOF
  sudo pip install .
  EOF
  not_if 'test -d /usr/local/lib/python2.7/dist-packages/novadocker'
end
