file_cache_path "/tmp/chef-solo"

base = File.expand_path("..", __FILE__)

cookbook_path [base + "/cookbooks", base + "/site-cookbooks"]
