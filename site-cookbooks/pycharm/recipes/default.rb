#
# Cookbook Name:: pycharm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

package "openjdk-7-jdk" do
  action :install
end

# set JAVA_HOME if it doesn't exist
bash "set JDK_HOME in .bashrc" do
  not_if "grep JDK_HOME #{node.home + "/.bashrc"}"
  cwd node.home
  code <<-EOL
    echo 'export JDK_HOME=/usr/lib/jvm/java-7-openjdk-amd64' >> .bashrc
  EOL
end


installer_file = "pycharm-community-4.0.4.tar.gz"
installer_url = "http://download.jetbrains.com/python/pycharm-community-4.0.4.tar.gz"
# get binary
remote_file "/tmp/"+installer_file do
  action :create_if_missing
  source installer_url
end

# extract files to /srcdir/rustc-nightly
#
tar_dir = "pycharm-community-4.0.4"
bash "extract rust source files" do
  not_if {File.exists?(node.intelliJ.bin_path + "/pycharm")}
  user node.user
  code <<-EOL
    tar zxvf /tmp/#{installer_file} -C /tmp/
    mv /tmp/#{tar_dir} #{node.pycharm.bin_path}/pycharmDir
    ln -s #{node.intelliJ.bin_path}/pycharmDir/bin/pycharm.sh #{node.pycharm.bin_path}/pycharm
  EOL
end

