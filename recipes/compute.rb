#
# Cookbook Name:: devstack
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'devstack::base'

include_recipe 'devstack::docker'
include_recipe 'devstack::nova-docker'
include_recipe 'devstack::devstack'
include_recipe 'devstack::openstack-scripts'
include_recipe 'devstack::network'
