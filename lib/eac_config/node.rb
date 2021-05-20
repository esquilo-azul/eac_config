# frozen_string_literal: true

require 'eac_config/entry'
require 'eac_config/entry_path'
require 'eac_config/load_path'
require 'eac_config/load_nodes_search'
require 'eac_config/node_entry'
require 'eac_ruby_utils/core_ext'

module EacConfig
  module Node
    common_concern do
      enable_abstract_methods
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
      ::EacConfig::NodeEntry.new(self, path)
    end

    # @return [Array<EacConfig::Node>]
    def self_loaded_nodes
      load_path.paths.map { |node_path| load_node(node_path) }
    end

    # @return [Array<EacConfig::Node>]
    def recursive_loaded_nodes
      ::EacConfig::LoadNodesSearch.new(self).result
    end

    private

    def load_node(node_path)
      self.class.new(node_path.to_pathname.expand_path(path.parent))
    end
  end
end
