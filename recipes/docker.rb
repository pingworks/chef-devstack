# docker installation
#package 'linux-image-extra-virtual'
#package 'linux-image-extra-3.13.0-61-generic'

package 'apt-transport-https'

apt_repository 'docker' do
  uri 'https://apt.dockerproject.org/repo'
  distribution 'ubuntu-trusty'
  components ['main']
  keyserver 'p80.pool.sks-keyservers.net'
  key '58118E89F3A912897C070ADBF76221572C52609D'
  action :add
end

package 'docker-engine'

service 'docker' do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

cookbook_file 'default-docker' do
  path '/etc/default/docker'
  mode '0600'
  owner 'root'
  group 'root'
  notifies :restart, 'service[docker]', :delayed
end
