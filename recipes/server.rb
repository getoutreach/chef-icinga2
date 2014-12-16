#
# Cookbook Name:: icinga2
# Recipe:: server
#
# Copyright 2014, Virender Khatri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# setup apache and icinga2 vhost
case node['icinga2']['web_engine']
when 'apache'
  include_recipe 'icinga2::server_apache'
else
  fail "unknown web engine '#{node['icinga2']['web_engine']}'"
end

# install icinga2 packages
include_recipe 'icinga2::server_install'

# configure icinga2 server
include_recipe 'icinga2::server_core'

# icinga2 classic ui
include_recipe 'icinga2::server_classic_ui'

# objects
include_recipe 'icinga2::server_objects' if node['icinga2']['disable_default_conf']

service 'icinga2' do
  service_name node['icinga2']['service_name']
  supports :status => true, :reload => true, :restart => true
  action [:enable, :start]
end