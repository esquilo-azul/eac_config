# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_ruby_utils/core_ext'

module EacConfig
  class LoadPath
    ENTRY_PATH = ::EacConfig::EntryPath.assert(%w[load_path])

    common_constructor :node

    def entry
      node.self_entry(ENTRY_PATH)
    end

    # @return [Array<String>]
    def paths
      r = entry.value
      r.is_a?(::Array) ? r : []
    end

    def push(new_path)
      entry.value = paths + [new_path]
    end
  end
end
