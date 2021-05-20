# frozen_string_literal: true

require 'addressable'
require 'eac_config/node'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/yaml'

module EacConfig
  class YamlFileNode
    include ::EacConfig::Node

    common_constructor :path do
      self.path = path.to_pathname
    end

    def data
      @data ||= ::EacRubyUtils::Yaml.load_file(assert_path)
    end

    def url
      ::Addressable::URI.parse("file://#{path.expand_path}")
    end

    private

    def assert_path
      unless path.file?
        raise("\"#{path}\" is a not a file") if path.exist?

        persist_data({})
      end
      path
    end
  end
end
