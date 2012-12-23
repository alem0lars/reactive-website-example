desc 'Start the rails server in debugging mode'
task :server do
  sh 'rails server --debugger', :verbose => false
end
