#
# Cookbook Name:: devstack
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

if node['devstack']['type']=='ctrl' then
  include_recipe 'devstack::ctrl'
end
if node['devstack']['type']=='compute' then
  include_recipe 'devstack::compute'
end
