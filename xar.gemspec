# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "xar"
  spec.version       = "0.0.1"
  spec.authors       = ["Adam Tanner", "Ribose Inc."]
  spec.email         = ["adam@adamtanner.org", "open.source@ribose.com"]
  spec.summary       = %q{ Ruby FFI bindings to libxar. }
  spec.description   = %q{ Ruby FFI bindings to libxar. }
  spec.homepage      = "https://github.com/adamtanner/xar"
  spec.license       = "MIT"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`
      .split("\x0").reject { |f| f.match(%r{^(.github|test|spec|features)/}) } +
    Dir.glob("lib/xar.bundle")
  end

  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ffi", "~> 1.14"
  spec.add_runtime_dependency "ffi-stat", "~> 0.3"

  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "mini_portile2"
  spec.add_development_dependency "rake-compiler-dock", "~> 1.1"
end
