# Colorize the capistrano outputs
require 'capistrano_colors'

# Run bundle install on cap deploy
require 'bundler/capistrano'

# { Enable rvm integration for capistrano
# The rvm string (<ruby_version>@<gemset>) which the application will run into
set :rvm_ruby_string, '1.9.2@higgs_website'
# The rvm installation type (system or user)
set :rvm_type, :system
# Require the library to integrate rvm with capistrano
require 'rvm/capistrano'
# On cap deploy:setup, install the ruby version and the gemset
before 'deploy:setup', 'rvm:install_ruby'
# }

# The application name
set :application, 'higgs_website'

# The server location
server 'nextreamlabs.org', :app, :web, :db, :primary => true
# Path where the files will get deployed in
set :deploy_to, "/usr/local/private_www/#{application}"

# Allocate a 'pseudo-tty' for every command, otherwise some programs don't run correctly
# (e.g. remote git commands don't prompt for a password and fail silently)
default_run_options[:pty] = true

# Use the SSH keys from the local account (instead of the remote one)
ssh_options[:forward_agent] = true
# Remote SSH username
ssh_options[:username] = 'worker'
# Disable SSH compression to prevent to freed the stream prematurely
ssh_options[:compression] = 'none'

# SCM repository URI
# (it must contain the username to be used for git operations)
set :repository,  'git@nextreamlabs.org:higgs_website.git'
# SCM to be used
set :scm, :git
# Reuse the same remote git clone multiple times
set :deploy_via, :remote_cache

# Don't use the superuser on the remote machine
set :use_sudo, false

# Number of releases to keep
set :keep_releases, 8
# Clean old releases at each deployment, but keep the 'number of releases to keep'
after 'deploy:restart', 'deploy:cleanup'

# Enable unicorn integration for capistrano
# (add hooks to start,stop,restart the unicorn server)
require 'capistrano-unicorn'

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
after 'deploy', 'rvm:trust_rvmrc'
