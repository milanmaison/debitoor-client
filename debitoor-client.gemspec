# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'debitoor/version'

Gem::Specification.new do |spec|
  spec.name          = "debitoor-client"
  spec.version       = Debitoor::VERSION
  spec.authors       = ["Alessio Santo"]
  spec.email         = ["alessio.santocs@gmail.com"]

  spec.summary       = "Simple ruby client to Debitoor invoicing software api"
  spec.description   = "Simple ruby client to Debitoor invoicing software api"
  spec.homepage      = "https://github.com/milanmaison/debitoor-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
