# frozen_string_literal: true

module EacConfig
  class NodeUri
    enable_simple_cache
    common_constructor :source, :loader_uri, default: [nil]

    def available_node_classes
      require 'eac_config/yaml_file_node'
      [::EacConfig::YamlFileNode]
    end

    def instanciate
      available_node_classes.lazy.map { |k| k.from_uri(self) }.find(&:present?) ||
        raise("No class mapped for \"#{to_addressable}\"")
    end

    delegate :to_s, to: :to_addressable

    private

    def to_addressable_uncached
      r = ::Addressable::URI.parse(source)
      path = r.path.to_pathname
      r.path = path.expand_path(loader_uri_path_directory).to_path if path.relative?
      r.scheme = 'file' if r.scheme.blank?
      r
    end

    def loader_uri_path_directory
      r = loader_uri.path
      raise ".loader_uri \"#{loader_uri}\" has no path (Source: \"#{source}\")" if r.blank?

      r.to_pathname.parent
    end
  end
end
