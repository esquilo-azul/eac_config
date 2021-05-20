# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_config/paths_hash'
require 'eac_ruby_utils/core_ext'

module EacConfig
  # A entry which search values only in the source node.
  class NodeEntry
    enable_simple_cache
    common_constructor :node, :path do
      self.path = ::EacConfig::EntryPath.assert(path)
    end

    def found?
      paths_hash.key?(to_paths_hash_key)
    end

    def value
      paths_hash[to_paths_hash_key]
    end

    def value=(a_value)
      paths_hash[to_paths_hash_key] = a_value
      node.persist_data(paths_hash.root.to_h)
    end

    private

    # @return [EacConfig::PathsHash]
    def paths_hash_uncached
      ::EacConfig::PathsHash.new(node.data)
    end

    def to_paths_hash_key
      path.parts.join('.')
    end
  end
end
