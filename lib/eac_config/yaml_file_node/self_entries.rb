# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_config/yaml_file_node/entry'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/wildcards'

module EacConfig
  class YamlFileNode
    class SelfEntries
      acts_as_instance_method
      common_constructor :node, :path do
        self.path = ::EacConfig::EntryPath.assert(path)
      end

      # @return [Array<EacConfig::YamlFileNode>]
      def result
        head_node.result.map { |found_path| ::EacConfig::YamlFileNode::Entry.new(node, found_path) }
      end

      private

      # @return [DataNode]
      def head_node
        DataNode.new(node.data, ::EacConfig::EntryPath.new, path)
      end

      class DataNode
        common_constructor :data_node, :path_from, :path_to do
          self.data_node = data_node.stringify_keys if data_node.is_a?(::Hash)
        end

        # @return [DataNode]
        def child(child_key)
          self.class.new(data_node.fetch(child_key), path_from.with_last(child_key),
                         path_to.without_first)
        end

        def children
          return [] unless data_node.is_a?(::Hash)

          data_node.keys.select { |k| key_matcher.match?(k) }.map { |k| child(k) } # rubocop:disable Style/SelectByRegexp
        end

        # @return [Symbol]
        def key
          path_to.first
        end

        # @return [EacRubyUtils::Wildcards]
        def key_matcher
          @key_matcher ||= ::EacRubyUtils::Wildcards.new(key)
        end

        # @return [Array<EacConfig::EntryPath>]
        def result
          (path_to.empty? ? result_from_self : result_from_children)
        end

        # @return [Array<EacConfig::EntryPath>]
        def result_from_self
          [path_from]
        end

        # @return [Array<EacConfig::EntryPath>]
        def result_from_children
          children.flat_map(&:result)
        end
      end
    end
  end
end
