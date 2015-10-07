
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
  EOF
  not_if 'test -d /home/ubuntu/nova-docker/.git'
end

cookbook_file '0001-Fix-key-injection-when-nova-is-running-as-non-root-u.patch' do
  path '/home/ubuntu/nova-docker/0001-Fix-key-injection-when-nova-is-running-as-non-root-u.patch'
  owner 'root'
  group 'root'
  mode '644'
end

cookbook_file '0002-modify-requirements-to-match-keystone-requirements.patch' do
  path '/home/ubuntu/nova-docker/0002-modify-requirements-to-match-keystone-requirements.patch'
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
  # Cherry pick the 'lo interface up' and mtu fix from master
  git cherry-pick ba545170399bbb76e8b2c26ecc082be5e867ee8d
  git cherry-pick 12b11b31b6f4274efa88f3011d2e4b884ed0e30c
  git cherry-pick 3b3a0c744de288ef3477c6b2940e6308357777f2
  git cherry-pick 005921b0741f6753799807af6b4444153888851a
  git am < 0001-Fix-key-injection-when-nova-is-running-as-non-root-u.patch
  git am < 0002-modify-requirements-to-match-keystone-requirements.patch
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

directory '/etc/nova/rootwrap.d' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

remote_file 'docker.filtes' do
  path '/etc/nova/rootwrap.d/docker.filters'
  source 'file:///home/ubuntu/nova-docker/etc/nova/rootwrap.d/docker.filters'
end
