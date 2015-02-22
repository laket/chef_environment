#
# Cookbook Name:: pylearn2
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# install pylearn2 to ~/lib 

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

lib_dir = node.home + "/lib"
pylearn2_dir = lib_dir + "/pylearn2"

directory lib_dir do
  owner node.user
  group node.user
  action :create
end  


git lib_dir + "/Theano" do
  user node.user
  group node.user
  repository "git://github.com/Theano/Theano.git"
  reference "master"
  action :checkout
end  

# TODO: put not_if to stop multiple install.
bash "setup theano" do
  not_if "pydoc modules | grep theano"
  cwd lib_dir + "/Theano"
  
  code <<-EOL
    python setup.py develop
  EOL
end



# get from repository
# https://github.com/rust-lang/rust-mode
git pylearn2_dir do
  user node.user
  group node.user
  repository "git://github.com/lisa-lab/pylearn2.git"
  reference "master"
  action :checkout
end

bash "setup pylearn2" do
  not_if "pydoc modules | grep pylearn2n"  
  cwd pylearn2_dir
  
  code <<-EOL
    python setup.py develop
  EOL
end

# chown related directories.
# If we don't do this, we can't use theano
bash "chown .theano" do
  code <<-EOL
    chown -R #{node.user + "." + node.user} #{node.home + "/.theano"}
  EOL
end

data_dir = node.home + "/data"

# add a directory to store experiment data.
directory data_dir do
  owner node.user
  group node.user
  action :create
end  

# add environment variable to .bashrc
bash "add PYLEARN2_DATA_PATH to .bashrc" do
  not_if "grep PYLEARN2_DATA_PATH #{node.home + "/.bashrc"}"
  
  code <<-EOL
    echo "export PYLEARN2_DATA_PATH=#{data_dir}" >> #{node.home + "/.bashrc"}
  EOL
end

  
