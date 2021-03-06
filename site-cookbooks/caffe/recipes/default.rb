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

%w{libboost-all-dev libgoogle-glog-dev libgflags-dev protobuf-compiler libprotobuf-dev python-protobuf libatlas-dev}.each do |pkg|
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
    update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
    update-alternatives --install /usr/bin/python python #{node.caffe.anaconda_path}/bin/python2.7 2

    echo "export PATH=#{node.caffe.anaconda_path}/bin:$PATH" >> #{node.home} + "/.bashrc"
    echo "export LD_LIBRARY_PATH=#{node.caffe.anaconda_path}/lib:$LD_LIBRARY_PATH"
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
requirement_path = node.caffe.caffe_path + "/python/requirements.txt"
bash "install caffe dependencies" do
  code <<-EOL        
    for req in $(cat #{requirement_path}); do #{node.caffe.anaconda_path}/bin/pip install $req; done
  EOL
end

# get configured Makefile
cookbook_file node.caffe.cafef_path+"/Makefile.config" do 
  source "Makefile.config"
  owner node.user
  group node.user
  mode 0644
end


bash "run make" do
  cwd node.caffe.caffe_path
  
  code <<-EOL
    mkdir -p ./include/proto
    protoc ./src/caffe/proto/caffe.proto --cpp_out=./include/proto

    make -j 4 all
    make -j 4 test
    make runtest
  EOL
end  
