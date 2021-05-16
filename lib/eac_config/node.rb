# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_config/load_nodes_search'
require 'eac_ruby_utils/core_ext'

module EacConfig
  module Node
    common_concern do
      enable_abstract_methods
      include ::Comparable
    end

    LOAD_PATH_ENTRY_PATH = ::EacConfig::EntryPath.assert(%w[load_path])
    LOAD_PATH_PATH_SEPARATOR = ':'

    def entry(path)
      ::EacConfig::EntrySearch.new(self, ::EacConfig::EntryPath.assert(path)).result
    end

    # @return [Addressable::URI]
    def url
      raise_abstract_method(__method__)
    end

    # @return [Array<EacConfig::Node>]
    def self_loaded_nodes
      ::EacConfig::EntrySearch.new(self, ::EacConfig::EntryPath.assert(LOAD_PATH_ENTRY_PATH))
                              .result_from_self.if_present([]) do |e|
        e.value.split(LOAD_PATH_PATH_SEPARATOR).map { |node_path| load_node(node_path) }
      end
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
