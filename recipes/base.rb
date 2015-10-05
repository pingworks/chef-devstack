# use de.archive.ubuntu.com
cookbook_file 'sources-list' do
  path '/etc/apt/sources.list'
  owner 'root'
  group 'root'
  mode '644'
end

# apt-get update
node.force_override['apt']['periodic_update_min_delay'] = 0
include_recipe 'apt'

include_recipe 'devstack::ubuntu-user'
include_recipe 'devstack::sysctl'
