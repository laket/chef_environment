#
# Cookbook Name:: kivy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

source_file = "/tmp/Kivy-1.9.0.tar.gz"
source_url = "https://pypi.python.org/packages/source/K/Kivy/Kivy-1.9.0.tar.gz"
# get source code
remote_file source_file do
  action :create_if_missing
  source source_url
end



%w{aptitude build-essential git libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libportmidi-dev libswscale-dev libavformat-dev libavcodec-dev zlib1g-dev libgstreamer1.0-dev libav-tools}.each do |pkg|
  package pkg do
    action :install
  end
end


bash "install cython" do
  code <<-EOL
    #{node.anaconda_path}/bin/conda install cython=0.21.2
  EOL
end
  
bash "run kivy install" do
  code <<-EOL
    mkdir -p /tmp/kivy
    tar xzvf #{source_file} -C /tmp/kivy
    cd /tmp/kivy/Kivy-1.9.0/ ; #{node.python_path + "/python"} setup.py install
  EOL
end

#install kivy-designer
git node.home + "/lib/kivy-designer" do
  repository "https://github.com/kivy/kivy-designer.git"
  reference "master"
  action :checkout
end


bash "install requirements" do
  code <<-EOL
    #{node.anaconda_path}/bin/pip install -U watchdog pygments docutils jedi gitpython six kivy-garden
    #{node.anaconda_path}/bin/garden install filebrowser
  EOL
end
