lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zenodo/version'

Gem::Specification.new do |spec|
  spec.name          = 'zenodo-client'
  spec.version       = Zenodo::VERSION
  spec.authors       = ['Finn Bacall']
  spec.email         = ['finn.bacall@manchester.ac.uk']
  spec.summary       = "A client to interact with Zenodo's REST API"
  spec.description   = "A client to interact with Zenodo's REST API, " \
      "as described at https://zenodo.org/dev"
  spec.homepage      = 'https://github.com/seek4science/zenodo-client'
  spec.license       = 'BSD'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']


  spec.required_ruby_version = '>= 1.9.3'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'test-unit', '~> 3.0'
  spec.add_runtime_dependency 'json', '~> 1.8'
  spec.add_runtime_dependency 'rest-client', '~> 1.7'
end
