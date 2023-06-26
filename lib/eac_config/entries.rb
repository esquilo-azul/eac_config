# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_ruby_utils/core_ext'

module EacConfig
  class Entries
    require_sub __FILE__
    enable_simple_cache
    common_constructor :root_node, :path do
      self.path = ::EacConfig::EntryPath.assert(path)
    end

    def to_s
      "#{self.class}[RootNode: #{root_node}, Path: #{path}]"
    end

    private

    # @return [Array<EacConfig::Entries>]
    def node_entries_uncached
      node_entries_from_root + node_entries_from_load_path
    end

    # @return [Array<EacConfig::Entries>]
    def node_entries_from_load_path_uncached
      root_node.recursive_loaded_nodes.flat_map { |loaded_node| loaded_node.self_entries(path) }
    end

    # @return [Array<EacConfig::Entries>]
    def node_entries_from_root_uncached
      root_node.self_entries(path)
    end
  end
end
