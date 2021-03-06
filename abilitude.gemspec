# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'abilitude/version'

Gem::Specification.new do |spec|
  spec.name          = 'abilitude'
  spec.version       = Abilitude::VERSION
  spec.authors       = ['Dimas Cyriaco']
  spec.email         = ['dimascyriaco@gmail.com']
  spec.description   = %q{Abilitude}
  spec.summary       = %q{Abilitude}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/) - %w[.gitignore]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
end
