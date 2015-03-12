#
# Cookbook Name:: rust
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

package "curl" do
  action :install
end

emacs_folder = node.home + "/.emacs.d"
  
bash "run setup" do
  not_if "which rustc"
  
  code <<-EOC
    wget https://static.rust-lang.org/rustup.sh
    sh rustup.sh
  EOC
end  

source_file = "rustc-nightly-src.tar.gz"
source_url = "https://static.rust-lang.org/dist/rustc-nightly-src.tar.gz"
# get source code
remote_file "/tmp/"+source_file do
  action :create_if_missing
  source source_url
end

# extract files to /srcdir/rustc-nightly
rustc_srcdir = node.rust.src_path + "/rustc-nightly/src"
bash "extract rust source files" do
  not_if {Dir.exist?(rustc_srcdir)}
  
  code <<-EOL
    install -d #{node.rust.src_path}
    tar zxvf /tmp/#{source_file} -C #{node.rust.src_path}
    chmod 0775 #{node.rust.src_path + "/rustc-nightly"}
    chown -R #{node.user + "." + node.user} #{rustc_srcdir}

  EOL
end

# install rust-mode
# https://github.com/rust-lang/rust-mode
git emacs_folder + "/rust-mode" do
  repository "https://github.com/rust-lang/rust-mode.git"
  reference "master"
  action :checkout
end

# change owner of rust-mode folder
directory emacs_folder + "/rust-mode" do
  only_if { Dir.exist?(emacs_folder + "/rust-mode") }
  action :create
  group node.user
  owner node.user
end

# ********* comment out racer **********
# we can't build racer under nightly building rust.

# install Racer (code completion for Rust)
#racer_root = node.rust.src_path + "/racer"
#git racer_root do
#  repository "https://github.com/phildawes/racer.git"
#  reference "master"
#  action :checkout
#end
#
#bash "compile racer" do
#  cwd racer_root
#  code <<-EOC
#    cargo build --release
#  EOC
#end

  
template emacs_folder + "/rust.el" do
  source "rust.el"
  owner node.user
  group node.user
  mode 0644
  variables(
            :rustc_srcdir=> rustc_srcdir
#            :racer_cmd_path=> racer_root+"/target/release/racer",
#            :racer_editors=> racer_root+"/editors"
  ) 
end

#### start for ctag #####
package "exuberant-ctags" do
  action :install
end  

rust_src_path = node.rust.src_path + "/rustc-nightly/src"
rust_ctag_file_path = rust_src_path + "/etc/ctags.rust"

file node.home + "/.ctags" do
  owner node.user
  action :create
  content IO.read(rust_ctag_file_path)
end  

directory node.home + "/lib" do
  owner node.user
  group node.user
  action :create
end  

bash "create TAGS for etag" do
  not_if {File.exist?(node.home + "/lib/rust.tags")}
  cwd node.home + "/lib"
  user node.user
  code <<-EOL
    ctags --language=Rust -e -f rust.tags -R #{rust_src_path}
  EOL
end

#### end for gtag #####


# edit init.el (This requires basetools)
load_sentence = "(load-file \"~/.emacs.d/rust.el\")"
init_path = emacs_folder + "/init.el"

bash "edit init.el to load rust.el" do
  not_if "grep '#{load_sentence}' #{init_path}"
  code "echo '#{load_sentence}' >> #{init_path}"
end

