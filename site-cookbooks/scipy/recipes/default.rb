#
# Cookbook Name:: scipy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# install scipy from source code.
# This follows http://www.scipy.org/scipylib/building/linux.html

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

# install dependent packages
package "python-setuptools" do
  action :install
end

# we can alternatively use libopenblas-base.
package "libatlas3-base" do
  action :install
end


package "python2.7-numpy" do
  action :install
end

package "python2.7-scipy" do
  action :install
end
