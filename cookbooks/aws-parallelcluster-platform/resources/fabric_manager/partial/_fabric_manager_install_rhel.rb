# frozen_string_literal: true
#
# Copyright:: 2013-2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
# http://aws.amazon.com/apache2.0/
#
# or in the "LICENSE.txt" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.

action :install_package do
  remote_file "#{node['cluster']['sources_dir']}/#{fabric_manager_package}-#{fabric_manager_version}.rpm" do
    source "#{fabric_manager_url}"
    mode '0644'
    retries 3
    retry_delay 5
    action :create_if_missing
  end

  package 'yum-plugin-versionlock'
  bash "Install #{fabric_manager_package}" do
    user 'root'
    cwd node['cluster']['sources_dir']
    code <<-FABRIC_MANAGER_INSTALL
    set -e
    yum install -y #{fabric_manager_package}-#{fabric_manager_version}.rpm
    yum versionlock #{fabric_manager_package}
    FABRIC_MANAGER_INSTALL
    retries 3
    retry_delay 5
  end
end

def arch_suffix
  arm_instance? ? 'aarch64' : 'x86_64'
end

def fabric_manager_url
  "#{node['cluster']['artifacts_s3_url']}/dependencies/nvidia_fabric/#{platform}/#{fabric_manager_package}-#{fabric_manager_version}-1.#{arch_suffix}.rpm"
end
