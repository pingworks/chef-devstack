
# deps for devstack installation
package 'git'

bash 'checkout devstack' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu'
  code <<-EOF
  git clone -b stable/kilo #{node['devstack']['gitmirror']}/openstack-dev/devstack
  EOF
  not_if 'test -d /home/ubuntu/devstack/.git'
end

include_recipe 'devstack::designate'

template '/home/ubuntu/devstack/local.conf' do
  source 'local-conf.erb'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0644'
end

bash 'install devstack' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu/devstack'
  code <<-EOF
  export HOME=/home/ubuntu
  ./stack.sh
  sudo iptables -t nat -A POSTROUTING -o #{node['devstack']['external_iface']} -j MASQUERADE
  EOF
  not_if 'test -f /home/ubuntu/devstack/stack-screenrc'
end

remote_file 'docker.filtes' do
  path '/etc/nova/rootwrap.d/docker.filters'
  source 'file:///home/ubuntu/nova-docker/etc/nova/rootwrap.d/docker.filters'
end

cookbook_file 'rc-local' do
  path '/etc/rc.local'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file 'dnsmasq-neutron.conf' do
  path '/etc/neutron/dnsmasq-neutron.conf'
  owner 'root'
  group 'root'
  mode '0755'
end
