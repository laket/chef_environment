#
# Cookbook Name:: pyside
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

source_file = "/tmp/qt-unified-linux-x64-online.run"
source_url = "http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run"
# get source code
remote_file source_file do
  action :create_if_missing
  source source_url
end


bash "run Qt install" do
  code <<-EOL
    chmod +x #{source_file}
    #{source_file}
  EOL
end

