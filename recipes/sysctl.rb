cookbook_file 'sysctl-60-openstack.conf' do
  path '/etc/sysctl.d/60-openstack.conf'
  owner 'root'
  group 'root'
  mode '644'
end

bash 'reload sysctl' do
  code <<-EOF
  sysctl -p
  EOF
end
