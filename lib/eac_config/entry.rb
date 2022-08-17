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

    def secret_value
      node_entry.if_present(&:secret_value)
    end

    def to_s
      "#{self.class}[RootNode: #{root_node}, Path: #{path}]"
    end

    def value
      node_entry.if_present(&:value)
    end

    def value=(a_value)
      write_node.self_entry(path).value = a_value
    end

    def write_node
      root_node.write_node || root_node
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
