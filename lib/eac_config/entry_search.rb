# frozen_string_literal: true

require 'eac_config/entry'
require 'eac_config/paths_hash'

module EacConfig
  class EntrySearch
    enable_simple_cache
    common_constructor :node, :path

    private

    def result_from_self_uncached
      return nil unless paths_hash.key?(to_paths_hash_key)

      ::EacConfig::Entry.new(node, path, true, paths_hash.fetch(to_paths_hash_key))
    end

    def result_not_found_uncached
      ::EacConfig::Entry.new(nil, path, false, nil)
    end

    # @return [EacConfig::Entry]
    def result_uncached
      result_from_self || result_not_found
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
