# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacConfig
  class EntryPath
    PART_SEPARATOR = '.'

    class << self
      def assert(source)
        source.is_a?(self) ? source : new(build_parts(source))
      end

      def build_parts(source)
        return validate_parts!(source.split(PART_SEPARATOR)) if source.is_a?(::String)
        return validate_parts!(source.flat_map { |part| build_parts(part) }) if
        source.is_a?(::Enumerable)

        build_parts(source.to_s)
      end

      def validate_parts!(parts)
        parts.assert_argument(::Enumerable, 'parts')
        parts.each_with_index do |part, index|
          raise ::ArgumentError, "Part #{index} of #{parts} is blank" if part.blank?
          raise ::ArgumentError, "Part #{index} is not a string" unless part.is_a?(::String)
        end
      end
    end

    common_constructor :parts, default: [[]] do
      self.parts = ::Array.new(parts).freeze
    end

    compare_by :parts
    delegate :any?, :count, :each, :each_value, :each_with_index, :empty?, :fetch, :first, :index,
             :inject, :last, :map, :size, to: :parts

    # @return [EacConfig::EntryPath]
    def +(other)
      self.class.new(parts + self.class.assert(other).parts)
    end

    def [](*args)
      slice(*args)
    end

    def slice(*args)
      r = parts.slice(*args)
      r.is_a?(::Enumerable) ? self.class.new(r) : r
    end

    def to_s
      "#{self.class}[#{to_string}]"
    end

    # @return [String]
    def to_string
      parts.join(PART_SEPARATOR)
    end
  end
end
