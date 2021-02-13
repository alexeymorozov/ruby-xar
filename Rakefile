require "bundler/gem_tasks"
require "rake/extensiontask"

spec = Gem::Specification.load("xar.gemspec")

Gem::PackageTask.new(spec) do |pkg|
end

# HACK: Prevent rake-compiler from overriding required_ruby_version,
# because the shared library here is Ruby-agnostic.
# See https://github.com/rake-compiler/rake-compiler/issues/153
module FixRequiredRubyVersion
  def required_ruby_version=(*); end
end
Gem::Specification.prepend(FixRequiredRubyVersion)

Rake::ExtensionTask.new("xar", spec)
