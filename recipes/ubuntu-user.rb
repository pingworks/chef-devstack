# set password 'ubuntu' for user ubuntu
user 'ubuntu' do
  home '/home/ubuntu'
  manage_home true
  shell '/bin/bash'
  password '$6$O5JfHwul$WYE3dbnP7uVBDcQJ55zLtC.vLSOW/4fOwStaGBzhfVUfOqN9hH.0sd9PcGZrw8OSZtKU7NXXUm1owOEEJo.2o0'
end

cookbook_file 'sudoers-ubuntu' do
  path '/etc/sudoers.d/ubuntu'
  owner 'root'
  group 'root'
  mode '644'
end
