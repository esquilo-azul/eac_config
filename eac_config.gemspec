# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_config/version'

Gem::Specification.new do |s|
  s.name        = 'eac_config'
  s.version     = EacConfig::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib}/**/*']
  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency 'addressable', '~> 2.8', '>= 2.8.7'
  s.add_dependency 'eac_ruby_utils', '~> 0.121'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.10'
end
