require "bundler/gem_tasks"
require "rake/extensiontask"

spec = Gem::Specification.load("xar.gemspec")

Gem::PackageTask.new(spec) do |pkg|
end

Rake::ExtensionTask.new("xar", spec) do |ext|
  ext.cross_compile = true
  ext.cross_platform = %w[x86-mingw32 x64-mingw32 x86-linux x86_64-linux]
  ext.cross_compiling do |s|
    s.files.reject! { |path| File.fnmatch?("ext/*", path) }
  end
end
