require 'rake/clean'
require 'rubygems/package_task'
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yard'

desc 'run rspec'
RSpec::Core::RakeTask.new(:spec)

CUKE_RESULTS = 'doc/cuke_results.html'
CLEAN << CUKE_RESULTS

YARD::Rake::YardocTask.new do |t|
end

spec = eval(File.read('rbspe.gemspec'))
Gem::PackageTask.new(spec) do |pkg|
	pkg.need_tar = true
	pkg.need_tar_gz = true
	pkg.need_tar_bz2 = true
	pkg.need_zip = true
end

task :package => :yard

require 'rbspe'
desc 'Give the rbspe version'
task :version do
	puts Rbspe::VERSION
end


desc 'Deploying rbspe application locally'
task :deploy => :package do
	puts `gem install "pkg/rbspe-#{Rbspe::VERSION}.gem"`
end

task :default => :spec
