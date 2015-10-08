template '/etc/network/interfaces' do
  source 'network-interfaces.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

if node['devstack']['type'] == 'gateway' then
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
else
  bash 'fix routing' do
    user 'root'
    code <<-EOH
    ip route del default
    ip route add default via #{node['devstack']['global_gw_ip']}
    EOH
  end
end
