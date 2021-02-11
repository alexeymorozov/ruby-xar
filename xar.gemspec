# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "xar"
  spec.version       = "0.0.0"
  spec.authors       = ["Adam Tanner"]
  spec.email         = ["adam@adamtanner.org"]
  spec.summary       = %q{ Ruby FFI bindings to libxar. }
  spec.description   = %q{ Ruby FFI bindings to libxar. }
  spec.homepage      = "https://github.com/adamtanner/xar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi"
  spec.add_dependency "ffi-stat"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
