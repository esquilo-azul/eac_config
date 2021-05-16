# frozen_string_literal: true

require 'eac_config/entry'
require 'eac_config/entry_search'
require 'eac_config/readable_node'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/yaml'

module EacConfig
  class YamlFileNode
    include ::EacConfig::ReadableNode

    common_constructor :path do
      self.path = path.to_pathname
    end

    def data
      @data ||= ::EacRubyUtils::Yaml.load_file(path)
    end

    def entry(*path)
      ::EacConfig::EntrySearch.new(self, ::EacConfig::EntryPath.assert(path)).result
    end
  end
end
