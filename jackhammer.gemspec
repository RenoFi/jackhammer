# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jackhammer'

Gem::Specification.new do |spec|
  spec.name          = 'jackhammer'
  spec.version       = Jackhammer::VERSION
  spec.authors       = ['Scott Serok']
  spec.email         = ['scott@renofi.com']

  spec.summary       = 'Jackhammer is an opinionated facde over RabbitMQ Bunny'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/renofi/jackhammer'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri']     = spec.homepage
  spec.metadata['source_code_uri']  = spec.homepage
  spec.metadata['changelog_uri']    = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bunny', '~> 2.14'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'bunny-mock', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74'
  spec.add_development_dependency 'rubocop-performance', '~> 1.4.1'
  spec.add_development_dependency 'byebug'
end
