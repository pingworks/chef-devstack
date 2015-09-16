template '/etc/network/interfaces' do
  source 'network-interfaces.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
