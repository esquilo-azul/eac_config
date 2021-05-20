# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_ruby_utils/core_ext'

module EacConfig
  class Entry
    enable_simple_cache
    common_constructor :root_node, :path do
      self.path = ::EacConfig::EntryPath.assert(path)
    end

    def found?
      node_entry.if_present(false, &:found?)
    end

    def found_node
      node_entry.if_present(&:node)
    end

    def value
      node_entry.if_present(&:value)
    end

    private

    def node_entry_uncached
      node_entry_from_root || node_entry_from_load_path
    end

    def node_entry_from_load_path_uncached
      root_node.recursive_loaded_nodes.lazy.map { |loaded_node| loaded_node.self_entry(path) }
               .find(&:found?)
    end

    def node_entry_from_root_uncached
      e = root_node.self_entry(path)
      e.found? ? e : nil
    end
  end
end
