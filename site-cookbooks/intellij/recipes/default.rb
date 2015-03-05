#
# Cookbook Name:: intellij
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# CAUTION : this installs Intellij 14.0.3

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

package "openjdk-7-jdk" do
  action :install
end

# set JAVA_HOME if it doesn't exist
bash "set JDK_HOME in .bashrc" do
  cwd node.home
  code <<-EOL
    echo 'export JDK_HOME=/usr/lib/jvm/java-7-openjdk-amd64' >> .bashrc
  EOL
end


installer_file = "ideaIC-14.0.3.tar.gz"
installer_url = "http://download.jetbrains.com/idea/ideaIC-14.0.3.tar.gz"
# get binary
remote_file "/tmp/"+installer_file do
  action :create_if_missing
  source installer_url
end

# extract files to /srcdir/rustc-nightly
#
tar_dir = "idea-IC-139.1117.1"
bash "extract rust source files" do
  user node.user
  code <<-EOL
    tar zxvf /tmp/#{installer_file} -C /tmp/
    mv /tmp/#{tar_dir} #{node.intelliJ.bin_path}/intelliJDir
    ln -s #{node.intelliJ.bin_path}/intelliJDir/bin/idea.sh #{node.intelliJ.bin_path}/intelliJ
  EOL
end

