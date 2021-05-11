# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_config/paths_hash/entry_key_error'

module EacConfig
  class PathsHash
    class Node
      PATH_SEARCH_UNENDED_ERROR_MESSAGE = 'Path search is not a Node and is not ended'

      def initialize(source_hash)
        source_hash.assert_argument(Hash, 'source_hash')
        @data = source_hash.map { |k, v| [k.to_sym, v.is_a?(Hash) ? Node.new(v) : v] }.to_h
      end

      def entry?(path_search)
        return false unless data.key?(path_search.cursor)
        return true if path_search.ended?
        return data.fetch(path_search.cursor).entry?(path_search.succeeding) if
          data.fetch(path_search.cursor).is_a?(Node)

        false # Paths continue and there is not available nodes
      end

      def fetch(path_search)
        if data.key?(path_search.cursor)
          node = data.fetch(path_search.cursor)
          return (node.is_a?(Node) ? node.to_h : node) if path_search.ended?
          return nil if node.blank?
          return node.fetch(path_search.succeeding) if node.is_a?(Node)
        end

        path_search.raise_error(PATH_SEARCH_UNENDED_ERROR_MESSAGE)
      end

      def to_h
        data.map { |k, v| [k, v.is_a?(Node) ? v.to_h : v] }.to_h
      end

      def read_entry(path_search)
        node = data[path_search.cursor]
        return (node.is_a?(Node) ? node.to_h : node) if path_search.ended?
        return nil if node.blank?
        return node.read_entry(path_search.succeeding) if node.is_a?(Node)

        path_search.raise_error(PATH_SEARCH_UNENDED_ERROR_MESSAGE)
      end

      def write_entry(path_search, value)
        if path_search.ended?
          data[path_search.cursor] = value.is_a?(Hash) ? self.class.new(value) : value
        else
          assert_data_node(path_search.cursor).write_entry(path_search.succeeding, value)
        end
      end

      private

      attr_reader :data

      def assert_data_node(key)
        data[key] = self.class.new({}) unless data[key].is_a?(Node)
        data[key]
      end
    end
  end
end
