#
# Cookbook Name:: golang
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

package "golang" do
  action :install
end

package "golang-mode" do
  action :install
end

path_config = node.home + "/.bashrc"

bash "add GOPATH to .bashrc" do
  not_if "grep GOPATH #{path_config}"
  code <<-EOL
    echo "export GOPATH=#{node.go.gopath}" >> #{path_config}
    echo "export PATH=\$PATH:\$GOPATH/bin" >> #{path_config} 
  EOL
end

ENV["GOPATH"] = node.go.gopath

# install godef and gocode
bash "install godef" do
  not_if "find #{node.go.gopath + "/bin"} -name godef"
  code <<-EOL
    go get -u code.google.com/p/rog-go/exp/cmd/godef
    go get -u github.com/nsf/gocode
    chown -R #{node.user + "." + node.user} #{node.go.gopath}
  EOL
end

package "gocode-auto-complete-el" do
  action :install
end  

# get go-eldoc
eldoc_path = node.home + "/.emacs.d/go-eldoc.el"
remote_file eldoc_path do
  not_if {File.exist?(eldoc_path)}
  source "https://raw.githubusercontent.com/syohex/emacs-go-eldoc/master/go-eldoc.el"
end

cookbook_file node.home+"/.emacs.d/my-go.el" do 
  source "my-go.el"
  owner node.user
  group node.user
  mode 0644
end

# make init.el to load my-go.el
init_el = node.home + "/.emacs.d/init.el"
bash "make init.el to load my-go.el" do
  not_if "grep my-go.el #{init_el}"
  code <<-EOL
    echo '(load-file "~/.emacs.d/my-go.el")' >> #{init_el}
  EOL
end
  
