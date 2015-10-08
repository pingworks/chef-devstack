
# deps for devstack installation
package 'git'
package 'python-pip'
package 'python-dev'


bash 'checkout devstack' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu'
  code <<-EOF
  git clone -b stable/kilo #{node['devstack']['gitmirror']}/openstack-dev/devstack
  EOF
  not_if 'test -d /home/ubuntu/devstack/.git'
end

cookbook_file '0001-Fix-global-requirements.patch' do
  path '/home/ubuntu/devstack/0001-Fix-global-requirements.patch'
  owner 'ubuntu'
  group 'ubuntu'
  mode '644'
end

bash 'patch devstack' do
  user 'ubuntu'
  group 'ubuntu'
  cwd '/home/ubuntu/devstack'
  code <<-EOF
  patch -p1 < 0001-Fix-global-requirements.patch
  EOF
  not_if 'grep "requests>=2.2.0,!=2.4.0,<2.8.0" /home/ubuntu/devstack/lib/infra'
end

include_recipe 'devstack::nova-docker'
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
  environment 'HOME' => '/home/ubuntu'
  code <<-EOF
  ./stack.sh
  EOF
  not_if 'test -f /home/ubuntu/devstack/stack-screenrc'
end

remote_file 'docker.filtes' do
  path '/etc/nova/rootwrap.d/docker.filters'
  source 'file:///home/ubuntu/nova-docker/etc/nova/rootwrap.d/docker.filters'
  only_if 'test -f /home/ubuntu/nova-docker/etc/nova/rootwrap.d/docker.filters'
  not_if 'test -f /etc/nova/rootwrap.d/docker.filters'
end

bash 'configure recursor' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if test -f /etc/powerdns/pdns.conf && ! grep recursor /etc/powerdns/pdns.conf >/dev/null; then
    echo "recursor=#{node['devstack']['dns_recursor_ip']}" >> /etc/powerdns/pdns.conf
    service pdns restart
  fi
  EOH
end

cookbook_file 'dnsmasq-neutron.conf' do
  path '/etc/neutron/dnsmasq-neutron.conf'
  owner 'root'
  group 'root'
  mode '0755'
end

bash 'start devstack from rc.local' do
  user 'root'
  code <<-EOH
  sed -i -e 's;exit 0;;' /etc/rc.local
  echo 'su -c "/usr/bin/screen -dm -c /home/ubuntu/devstack/stack-screenrc" -l ubuntu' >> /etc/rc.local
  EOH
  not_if 'grep "/home/ubuntu/devstack/stack-screenrc" /etc/rc.local'
end
