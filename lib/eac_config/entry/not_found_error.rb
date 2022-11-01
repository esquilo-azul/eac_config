# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacConfig
  class Entry
    class NotFoundError < ::RuntimeError
      def initialize(entry)
        super("Entry #{entry} not found")
      end
    end
  end
end
