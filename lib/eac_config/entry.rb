# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_ruby_utils/core_ext'

module EacConfig
  class Entry
    common_constructor :found_node, :path, :found, :value

    def found?
      found
    end
  end
end
