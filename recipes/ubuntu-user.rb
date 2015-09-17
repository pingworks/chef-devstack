# set password 'ubuntu' for user ubuntu
user 'ubuntu' do
  home '/home/ubuntu'
  manage_home true
  shell '/bin/bash'
  password '$6$tnB2UkeR$Eqc3yF8lO9ZXL9L/cozLcdnY1NUtuxcOck3e0KChiPP0fz.GZaAlyuWpLqUcDOPhN5nBvHLmqXZ3ifad59Eg/.'
end

cookbook_file 'sudoers-ubuntu' do
  path '/etc/sudoers.d/ubuntu'
  owner 'root'
  group 'root'
  mode '644'
end
