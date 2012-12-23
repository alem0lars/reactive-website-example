source :rubygems

gem 'rails',                '3.2.3'

gem 'pg',                   '~> 0.13.2'
gem 'pg_search',            '~> 0.5'
gem 'faker',                '~> 1.0.1'
gem 'rails_config',         '~> 0.3.0'
gem 'activeadmin',          '~> 0.4.4'
gem 'devise',               '~> 2.1.0'
gem 'kaminari',             '~> 0.13.0'
gem 'haml-rails',           '~> 0.3.4'
gem 'jquery-rails',         '~> 2.0.2'
gem 'gon',                  '~> 3.0.2'
gem 'knockoutjs-rails',     '~> 2.0.0'

group :doc do
  gem 'RedCloth',           '~> 4.2.9',   require: 'redcloth'
end

# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails',         '~> 3.2.3'
  gem 'compass-rails',      '~> 1.0.1'
  gem 'bootstrap-sass',     '~> 2.0.3'

  gem 'uglifier',           '~> 1.0.3'
end

group :development do
  # { capistrano
  gem 'capistrano',         '~> 2.12.0'
  gem 'capistrano_colors',  '~> 0.5.5'
  gem 'capistrano-unicorn', '~> 0.1.6'
  gem 'rvm-capistrano',     '~> 1.2.0'
  # }
  # { testing and debugging
  gem 'ruby-debug19',       '~> 0.11.6',  require: 'ruby-debug'
  # }
  # { misc
  gem 'awesome_print',      '~> 1.0.2'
  gem 'pry-rails',          '~> 0.1.6'
  gem 'railroady',          '~> 1.0.7' # It requires graphviz to be installed
  # }
end

group :test do
  gem 'ruby-prof',          '~> 0.11.2'
  gem 'factory_girl_rails', '~> 3.3.0'
  gem 'capybara',           '~> 1.1.2'
end

group :test, :development do
  gem 'database_cleaner',   '~> 0.7.2'
  gem 'rspec-rails',        '~> 2.10.1'
  gem 'guard',              '~> 1.0.3'
  gem 'guard-rspec',        '~> 0.7.2'
  gem 'guard-bundler',      '~> 0.1.3'
  gem 'guard-livereload',   '~> 0.4.2'
  gem 'rb-fsevent',         '~> 0.9.1'
end
