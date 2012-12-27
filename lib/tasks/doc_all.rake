namespace :doc do
  task :all do
    %w[
      doc:app
      doc:rails
      doc:guides
      doc:plugins
    ].each { |t| Rake::Task[t].invoke() }
  end
end
