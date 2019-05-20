source 'https://rubygems.org'

ruby '2.5.3', engine: 'jruby', engine_version: '9.2.6.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'autoprefixer-rails', '8.6.5'
gem 'bcrypt', '~> 3.1.7'
gem 'coffee-rails', '~> 4.2'
gem 'decisiontree'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jwt'
gem 'puma'
gem 'rails', '~> 5.1.4'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'sassc-rails', '>= 2.1.0'
gem 'sidekiq'
gem 'simple_command'
gem 'activerecord-jdbcsqlite3-adapter'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'warbler'

group :development, :test do
  gem "ruby-debug"
  gem 'capybara', '~> 2.13'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false, group: :test
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
