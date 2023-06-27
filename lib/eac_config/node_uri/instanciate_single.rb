# frozen_string_literal: true

module EacConfig
  class NodeUri
    class InstanciateSingle
      acts_as_instance_method
      enable_simple_cache
      common_constructor :node_uri, :instance_uri

      # @return [Array<Class>]
      def available_node_classes
        require 'eac_config/envvars_node'
        require 'eac_config/yaml_file_node'
        [::EacConfig::EnvvarsNode, ::EacConfig::YamlFileNode]
      end

      # @return [EacConfig::Node]
      def result
        available_node_classes.lazy.map { |k| k.from_uri(self) }.find(&:present?) ||
          raise("No class mapped for \"#{to_addressable}\"")
      end

      # @return [Addressable::URI]
      def to_addressable
        instance_uri.to_uri
      end
    end
  end
end
