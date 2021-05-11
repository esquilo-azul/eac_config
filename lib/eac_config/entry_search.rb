# frozen_string_literal: true

require 'eac_config/entry'
require 'eac_config/paths_hash'

module EacConfig
  class EntrySearch
    enable_simple_cache
    common_constructor :node, :path

    private

    # @return [EacConfig::Entry]
    def result_uncached
      if paths_hash.key?(to_paths_hash_key)
        ::EacConfig::Entry.new(node, path, true, paths_hash.fetch(to_paths_hash_key))
      else
        ::EacConfig::Entry.new(nil, path, false, nil)
      end
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
