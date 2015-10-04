#
# Cookbook Name:: caffe
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

ruby_block "check nvida & cuda installation" do
  block do
    raise "nvida drivier is not found" if not File.exist?("/proc/driver/nvidia/version")
    raise "cuda is not found" if not File.exist?(node.caffe.cuda_path + "/bin/nvcc")
  end
end

%w{libboost-all-dev libgoogle-glog-dev libgflags-dev protobuf-compiler libprotobuf-dev python-protobuf}.each do |pkg|
  package pkg do
    action :install
  end
end

# io dependencies
%w{libhdf5-dev libleveldb-dev libsnappy-dev liblmdb-dev libtiff4-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

# opencv
package "libopencv-dev" do
  action :install
end

remote_file "/tmp/AnacondaInstaller.sh" do
  source "https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.3.0-Linux-x86_64.sh"
  mode "0755"
  action :create_if_missing
end  

#install anaconda
bash "install anaconda" do
  #not_if "grep PYLEARN2_DATA_PATH #{node.home + "/.bashrc"}"
  not_if {Dir.exists?(node.caffe.anaconda_path)}
  
  code <<-EOL
    chmod +x /tmp/AnacondaInstaller.sh
    /tmp/AnacondaInstaller.sh -b -f -p #{node.caffe.anaconda_path}
  EOL
end

git node.caffe.caffe_path do
  user node.user
  group node.user
  repository "https://github.com/BVLC/caffe"
  reference "master"
  action :checkout
end  

# install dependencies
requirement_path = node.caffe.anaconda_path + "/python/requirements.txt"
bash "install caffe dependencies" do
  code <<-EOL
    for req in $(cat #{requirement_path}); do pip install $req; done
  EOL
end

bash "configure Makefile" do
  cwd node.caffe.caffe_path
  
  code <<-EOL
    protoc ./src/caffe/proto/caffe.proto --cpp_out=./include/proto

    cp Makefile.config.example Makefile.config
#    sed -i -e "s/# USE_CUDNN := 1/USE_CUDNN := 1/" Makefile.config
    sed -i -e "s!CUDA_DIR := /usr/local/cuda!CUDA_DIR := #{node.caffe.cuda_path}!" Makefile.config
    make -j 2 all
    make test
    make runtest
  EOL
end  
