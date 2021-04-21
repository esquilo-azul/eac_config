# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacConfig
  class Manager
    common_constructor :root_node

    # @return [EacConfig::Entry]
    def entry(*parts)
      root_node.entry(*parts)
    end
  end
end
