#
# Cookbook Name:: myemacs
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

# basic toolset
%w{aptitude screen git python ipython trash-cli}.each do |pkg|
  package pkg do
    action :install
  end
end

# bashrc
cookbook_file node.home+"/.bashrc" do 
  source "bashrc"
  owner node.user
  group node.user
  mode 0644
end

cookbook_file node.home+"/.bash_profile" do 
  source "bash_profile"
  owner node.user
  group node.user
  mode 0644
end


# editor
%w{emacs fonts-inconsolata auto-complete-el}.each do |pkg| 
  package pkg do
    action :install
  end
end

directory node.home+"/.emacs.d/" do
  owner node.user
  group node.user
  mode 0744
  action :create
end

# emacs config files
%w{init.el my-key-bind.el my-cpp.el}.each do |conf_emacs|

  cookbook_file node.home+"/.emacs.d/"+conf_emacs do 
    owner node.user
    group node.user
    mode 0644
  end

end
