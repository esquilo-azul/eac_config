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
        new if uri == URI
      end
    end

    # @param path [EacConfig::EntryPath]
    # @return [Array<EacConfig::Entries>]
    def self_entries(_path)
      []
    end

    def url
      URI
    end

    def to_s
      "#{self.class}[ObjectId: #{object_id}]}"
    end
  end
end
