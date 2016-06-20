require 'rake/clean'
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'

desc 'run rspec'
RSpec::Core::RakeTask.new(:spec)

CUKE_RESULTS = 'doc/cuke_results.html'
CLEAN << CUKE_RESULTS

YARD::Rake::YardocTask.new do |t|
end



task :default => :spec
