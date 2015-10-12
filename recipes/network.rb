template '/etc/network/interfaces' do
  source 'network-interfaces.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

template "/etc/network/interfaces.d/#{node['devstack']['service_iface']}.cfg" do
  source 'network-interfaces-service.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

if node['devstack']['roles'].include?('ctrl') then
  template '/etc/network/interfaces.d/br-ex.cfg' do
    source 'network-interfaces-br-ex.erb'
    owner 'root'
    group 'root'
    mode '0755'
  end
end

if node['devstack']['service_iface'] != node['devstack']['external_iface'] then
  template "/etc/network/interfaces.d/#{node['devstack']['external_iface']}.cfg" do
    source 'network-interfaces-external.erb'
    owner 'root'
    group 'root'
    mode '0755'
  end
end

if node['devstack']['roles'].include?('gateway') then
  bash 'setup masquerading' do
    user 'root'
    code "iptables -t nat -A POSTROUTING -o #{node['devstack']['external_iface']} -j MASQUERADE"
  end

  bash 'add masquerading to rc.local' do
    user 'root'
    code <<-EOH
    sed -i -e 's;exit 0;;' /etc/rc.local
    echo 'iptables -t nat -A POSTROUTING -o #{node['devstack']['external_iface']} -j MASQUERADE' >> /etc/rc.local
    EOH
    not_if 'grep "MASQUERADE" /etc/rc.local'
  end
end

if ! node['devstack']['roles'].include?('gateway') then
  bash 'fix routing' do
    user 'root'
    code <<-EOH
    ip route del default
    ip route add default via #{node['devstack']['global_gw_ip']}
    ip route add #{node['devstack']['router_public_network']} via #{node['devstack']['global_ctrl_ip']}
    EOH
  end
end
