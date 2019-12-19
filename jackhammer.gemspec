# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jackhammer/version'

Gem::Specification.new do |spec|
  spec.name          = 'jackhammer'
  spec.version       = Jackhammer::VERSION
  spec.authors       = ['Scott Serok']
  spec.email         = ['scott@renofi.com']

  spec.summary       = 'Jackhammer is an opinionated facade over RabbitMQ Bunny'
  spec.homepage      = 'https://github.com/renofi/jackhammer'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri']     = spec.homepage
  spec.metadata['source_code_uri']  = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin/|spec/|\.rub)}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bunny', '~> 2.14'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'bunny-mock'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'byebug'
end
