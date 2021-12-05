# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_config/envvars_node'

module EacConfig
  module Rspec
    module Setup
      def self.extended(obj)
        obj.rspec_config.around do |example|
          obj.on_envvars_load_path_clean(example)
        end
      end

      def on_envvars_load_path_clean(example)
        old_value = envvars_load_path_entry.value
        begin
          envvars_load_path_entry.value = old_value = []
          example.run
        ensure
          envvars_load_path_entry.value = old_value
        end
      end

      def envvars_load_path_entry
        ::EacConfig::EnvvarsNode.new.load_path.entry
      end
    end
  end
end
