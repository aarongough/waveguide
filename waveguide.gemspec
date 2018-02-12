# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "waveguide/version"

Gem::Specification.new do |spec|
  spec.name          = "waveguide"
  spec.version       = Waveguide::VERSION
  spec.authors       = ["Aaron Gough"]
  spec.email         = ["aaron@aarongough.com"]

  spec.summary       = %q{An ultra-fast serialization library.}
  spec.description   = %q{An ultra-fast serialization library.}
  spec.homepage      = "http://github.com/aarongough/waveguide."
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "active_model_serializers", "~> 0.10.0"
  spec.add_development_dependency "ruby-prof"
  spec.add_development_dependency "fasterer"
end
