# Encoding: utf-8
require 'bundler/setup'

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  require 'foodcritic'
  require 'foodcritic/rackspace/rules/version' # ensure loaded
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    # 'search_gems' doesn't work, but :search_gems does
    # rubocop:disable Style/HashSyntax
    t.options = { :search_gems => true }
    # rubocop:enable Style/HashSyntax
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

require 'kitchen'
desc 'Run Test Kitchen integration tests'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  sh 'kitchen test -c'
end

desc 'Destroy test kitchen instances'
task :destroy do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.destroy
  end
end

require 'rspec/core/rake_task'
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t, args|
  t.rspec_opts = 'test/unit'
end

# The default rake task should just run it all
task default: ['style', 'spec', 'integration']

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end
