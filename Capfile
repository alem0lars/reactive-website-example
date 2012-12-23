load 'deploy'
# Precompile rails assets
load 'deploy/assets'
# Load custom plugins
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
# Get deploy configurations
load 'config/deploy'
