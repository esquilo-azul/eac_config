# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacConfig
  class LoadNodesSearch
    common_constructor :root_node do
      add_next_pending until pending.empty?
    end

    def result
      added
    end

    private

    def added
      @added ||= []
    end

    def add_next_pending
      current = pending.pop
      current.self_loaded_nodes.each do |loaded_node|
        next if added.include?(loaded_node)

        added << loaded_node
        pending.push(loaded_node)
      end
    end

    def pending
      @pending ||= begin
        r = Queue.new
        r.push(root_node)
        r
      end
    end
  end
end
