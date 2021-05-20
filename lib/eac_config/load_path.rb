# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_ruby_utils/core_ext'

module EacConfig
  class LoadPath
    ENTRY_PATH = ::EacConfig::EntryPath.assert(%w[load_path])
    PATH_SEPARATOR = ':'

    class << self
      def paths_to_string(paths)
        paths.map(&:to_s).join(PATH_SEPARATOR)
      end

      def string_to_paths(string)
        string.to_s.split(PATH_SEPARATOR)
      end
    end

    common_constructor :node

    def entry
      node.self_entry(ENTRY_PATH)
    end

    # @return [Array<String>]
    def paths
      self.class.string_to_paths(entry.value)
    end

    def push(new_path)
      entry.value = self.class.paths_to_string(paths + [new_path])
    end
  end
end
