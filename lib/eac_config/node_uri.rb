# frozen_string_literal: true

module EacConfig
  class NodeUri
    enable_simple_cache
    common_constructor :source, :loader_uri, default: [nil]

    # @return [Array<EacConfig::Node>]
    def instanciate
      instance_uris.map { |uri| instanciate_single(uri) }
    end

    delegate :to_s, to: :to_addressable

    private

    # @return [Array<Addressable::URI>]
    def instance_uris
      if to_addressable.scheme == 'file'
        ::Pathname.glob(to_addressable.path).map do |found_path|
          ::Addressable::URI.new(scheme: 'file', path: found_path.to_path)
        end
      else
        [to_addressable]
      end
    end

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

    require_sub __FILE__, require_mode: :kernel
  end
end
