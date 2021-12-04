# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_config/envvars_node'

module EacConfig
  module Rspec
    module Setup
      def self.extended(obj)
        obj.clean_envvars_load_path
      end

      def clean_envvars_load_path
        ::EacConfig::EnvvarsNode.new.load_path.entry.value = []
      end
    end
  end
end
