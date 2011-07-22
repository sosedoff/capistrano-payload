# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-payload/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'capistrano-payload'
  gem.version     = CapistranoPayload::VERSION.dup
  gem.author      = 'Dan Sosedoff'
  gem.email       = 'dan.sosedoff@gmail.com'
  gem.homepage    = 'https://github.com/sosedoff/capistrano-payload'
  gem.summary     = %q{JSON webhook on capistrano deployments}
  gem.description = %q{Capistrano plugin that delivers JSON payload to the specified URL}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec', '~> 2.6'
  
  gem.add_runtime_dependency 'capistrano',  '~> 2.6'
  gem.add_runtime_dependency 'rest-client', '~> 1.6'
  gem.add_runtime_dependency 'multi_json',  '~> 1.0'
  gem.add_runtime_dependency 'builder',     '~> 3.0'
end