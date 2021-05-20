# frozen_string_literal: true

require 'eac_config/entry'
require 'eac_config/paths_hash'

module EacConfig
  class EntrySearch
    enable_simple_cache
    common_constructor :node, :path

    private

    def node_entry_or_nil(node_entry)
      return nil unless node_entry.if_present(false, &:found?)

      ::EacConfig::Entry.new(node_entry.node, node_entry.path, true, node_entry.value)
    end

    def result_from_load_path_uncached
      node_entry_or_nil(
        node.recursive_loaded_nodes.lazy.map { |loaded_node| loaded_node.self_entry(path) }
            .find(&:found?)
      )
    end

    def result_from_self_uncached
      node_entry_or_nil(node.self_entry(path))
    end

    def result_not_found_uncached
      ::EacConfig::Entry.new(nil, path, false, nil)
    end

    # @return [EacConfig::Entry]
    def result_uncached
      result_from_self || result_from_load_path || result_not_found
    end

    # @return [EacConfig::PathsHash]
    def paths_hash_uncached
      ::EacConfig::PathsHash.new(node.data)
    end

    def to_paths_hash_key
      path.parts.join('.')
    end
  end
end
