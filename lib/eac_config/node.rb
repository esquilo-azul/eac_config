# frozen_string_literal: true

require 'eac_config/entry'
require 'eac_config/entry_path'
require 'eac_config/load_path'
require 'eac_config/load_nodes_search'
require 'eac_config/node_entry'
require 'eac_config/node_uri'
require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/context'

module EacConfig
  module Node
    class << self
      def context
        @context ||= ::EacRubyUtils::Context.new
      end
    end

    attr_accessor :write_node

    common_concern do
      acts_as_abstract :self_entries
      include ::Comparable
    end

    def entry(path)
      ::EacConfig::Entry.new(self, path)
    end

    # @return [[EacConfig::IncludePath]]
    def load_path
      @load_path ||= ::EacConfig::LoadPath.new(self)
    end

    # @return [Addressable::URI]
    def url
      raise_abstract_method(__method__)
    end

    # Return a entry which search values only in the self node.
    # @return [EacConfig::NodeEntry]
    def self_entry(path)
      self_entry_class.new(self, path)
    end

    def self_entry_class
      self.class.const_get('Entry')
    end

    # @return [Array<EacConfig::Node>]
    def self_loaded_nodes
      load_path.paths.map { |node_path| load_node(node_path) }
    end

    # @return [Array<EacConfig::Node>]
    def recursive_loaded_nodes
      ::EacConfig::LoadNodesSearch.new(self).result
    end

    # @return [EacConfig::PrefixedPathNode]
    def with_prefix(path_prefix)
      require 'eac_config/prefixed_path_node'
      ::EacConfig::PrefixedPathNode.new(self, path_prefix)
    end

    private

    def load_node(node_path)
      ::EacConfig::NodeUri.new(node_path, url).instanciate
    end
  end
end
