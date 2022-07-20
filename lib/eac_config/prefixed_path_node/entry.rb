# frozen_string_literal: true

require 'eac_config/node_entry'
require 'eac_ruby_utils/core_ext'

module EacConfig
  class PrefixedPathNode
    class Entry < ::EacConfig::NodeEntry
      enable_simple_cache
      delegate :found?, :found_node, :secret_value, :value, :value=, :writ_node, to: :full_entry

      # @return [EacConfig::EntryPath]
      def full_path
        node.path_prefix + path
      end

      private

      # @return [EacConfig::NodeEntry]
      def full_entry_uncached
        node.from_node.entry(full_path)
      end
    end
  end
end
