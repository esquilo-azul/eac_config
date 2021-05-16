# frozen_string_literal: true

require 'eac_config/entry_path'
require 'eac_ruby_utils/core_ext'

module EacConfig
  module Node
    common_concern do
      enable_abstract_methods
    end

    def entry(path)
      ::EacConfig::EntrySearch.new(self, ::EacConfig::EntryPath.assert(path)).result
    end
  end
end
