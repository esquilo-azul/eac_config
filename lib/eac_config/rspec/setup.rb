# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/fs/temp'
require 'eac_config/envvars_node'
require 'eac_config/node'
require 'eac_config/yaml_file_node'

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

      def stub_eac_config_node(&node_builder)
        parent_self = self
        rspec_config.around do |example|
          ::EacRubyUtils::Fs::Temp.on_file do |file|
            ::EacConfig::Node
              .context.on(parent_self.stub_eac_config_node_build(file, &node_builder)) do
              example.run
            end
          end
        end
      end

      def stub_eac_config_node_build(file, &node_builder)
        node_builder.present? ? node_builder.call(file) : ::EacConfig::YamlFileNode.new(file)
      end
    end
  end
end
