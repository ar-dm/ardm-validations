# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-validations/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name             = "ardm-validations"
  gem.version          = DataMapper::Validations::VERSION

  gem.authors          = ['Martin Emde', "Guy van den Berg"]
  gem.email            = ['me@martinemde.com', "vandenberg.guy [a] gmail [d] com"]
  gem.description      = "Ardm fork of dm-validations"
  gem.summary          = gem.description
  gem.license          = "MIT"

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.rdoc]

  gem.homepage         = "http://github.com/ar-dm/ardm-validations"
  gem.require_paths    = ["lib"]
  gem.rubygems_version = "1.8.11"

  gem.add_runtime_dependency 'ardm-core', '~> 1.2'

  gem.add_development_dependency 'ardm-types', '~> 1.2'
  gem.add_development_dependency 'rake',       '~> 0.9'
  gem.add_development_dependency 'rspec',      '~> 1.3'
end

