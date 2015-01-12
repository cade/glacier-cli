# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glacier/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "glacier-cli"
  spec.version       = Glacier::CLI::VERSION
  spec.authors       = ["Cade Truitt"]
  spec.email         = ["cadetruitt@gmail.com"]
  spec.summary       = %q{Basic CLI for AWS Glacier to back up files.}
  spec.description   = %q{The hopefully simple way to get all those video files off of your wife's laptop.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
