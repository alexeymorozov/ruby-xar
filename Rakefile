require "bundler/gem_tasks"
require "rake/extensiontask"

spec = Gem::Specification.load("xar.gemspec")

Gem::PackageTask.new(spec) do |pkg|
end

Rake::ExtensionTask.new("xar", spec)
