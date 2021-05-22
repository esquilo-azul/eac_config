# frozen_string_literal: true

require 'eac_config/old_configs/base'
require 'yaml'

module EacConfig
  class OldConfigs
    class File < ::EacConfig::OldConfigs::Base
      attr_reader :path, :options

      # Valid options: [:autosave]
      def initialize(path, options = {})
        @path = path
        @options = options.to_sym_keys_hash.freeze
        super(raw_data_from_file)
      end

      def save
        ::FileUtils.mkdir_p(::File.dirname(path))
        ::File.write(path, data.to_h.to_yaml)
      end

      def load
        replace(raw_data_from_file)
      end

      def write(entry_key, entry_value)
        super
        save if autosave?
      end

      def autosave?
        options[:autosave] ? true : false
      end

      private

      def raw_data_from_file
        if ::File.exist?(path) && ::File.size(path).positive?
          ::YAML.load_file(path)
        else
          {}
        end
      end
    end
  end
end
