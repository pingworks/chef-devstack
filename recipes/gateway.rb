#
# Cookbook Name:: devstack
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'devstack::base'

include_recipe 'pw_openvpn'
include_recipe 'pw_dnsmasq'
include_recipe 'pw_wpasupplicant'
include_recipe 'devstack::network'
