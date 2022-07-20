# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_config/paths_hash'
require 'eac_ruby_utils/core_ext'

module EacConfig
  class PrefixedPathNode
    require_sub __FILE__
    include ::EacConfig::Node
    common_constructor :from_node, :path_prefix do
      self.path_prefix = ::EacConfig::EntryPath.assert(path_prefix)
    end

    def entry(path)
      ::EacConfig::Entry.new(self, path)
    end
  end
end
