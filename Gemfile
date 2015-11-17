source 'https://rubygems.org'

group :lint do
  gem 'foodcritic', '~> 3.0'
  gem 'foodcritic-rackspace-rules' # git: 'git@github.com:racker/foodcritic-rackspace-rules.git'
  gem 'rubocop', '~> 0.33.0', require: false
end

group :unit do
  # For when I need berkshelf to actually resolve:
  # gem 'berkshelf', path: '/home/mart6985/src/berkshelf'
  # gem 'solve', path: '/home/mart6985/src/solve'
  # gem 'molinillo', path: '/home/mart6985/src/molinillo'
  gem 'berkshelf', '~> 4'
  gem 'chefspec', '~> 4'
  gem 'chef-sugar'
end

group :kitchen_common do
  gem 'test-kitchen'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
  gem 'vagrant-wrapper'
end

group :kitchen_rackspace do
  gem 'kitchen-rackspace'
end

group :development do
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rubocop'
  gem 'fauxhai'
  gem 'pry-nav'
end
