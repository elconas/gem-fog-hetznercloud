lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/hetznercloud/version'

Gem::Specification.new do |spec|
  spec.name          = 'fog-hetznercloud'
  spec.version       = Fog::Hetznercloud::VERSION
  spec.authors       = ['Robert Heinzmann']
  spec.email         = ['reg@elconas.de']

  spec.summary       = 'Fog provider for Hetzner Cloud'
  spec.description   = 'Fog provider gem to support the Hetzner Cloud.'
  spec.homepage      = 'https://github.com/elconas/gem-fog-hetznerloud'
  spec.license       = 'APACHE-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'net-ssh'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'fog-core', '>= 1.45.0'
  spec.add_dependency 'fog-json', '>= 1.0.2'
  spec.add_dependency 'net-ssh', '~> 4.0'
end
