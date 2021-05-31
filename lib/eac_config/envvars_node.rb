# frozen_string_literal: true

require 'addressable'
require 'eac_config/node'
require 'eac_ruby_utils/core_ext'

module EacConfig
  # A node that read/write entries from environment variables.
  class EnvvarsNode
    require_sub __FILE__
    include ::EacConfig::Node

    URI = ::Addressable::URI.parse('self://envvars')

    class << self
      def from_uri(uri)
        return new if uri == URI
      end
    end

    def url
      URI
    end
  end
end
