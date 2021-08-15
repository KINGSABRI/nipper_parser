# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nipper_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "nipper_parser"
  spec.version       = NipperParser::VERSION
  spec.authors       = ["KING SABRI"]
  spec.email         = ["king.sabri@gmail.com"]

  spec.summary       = %q{Unofficial parser for Titania Nipper Studio XML report.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/KINGSABRI/nipper_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_runtime_dependency 'nokogiri', '~> 1.12', '>= 1.12.2'
  spec.add_development_dependency "bundler", '~> 2.2', '>= 2.2.10'
  spec.add_development_dependency "rake", '~> 12.3', '>= 12.3.3'
end
