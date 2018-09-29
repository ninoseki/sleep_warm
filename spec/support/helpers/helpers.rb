# frozen_string_literal: true

require "json"

module Spec
  module Support
    module Helpers
      def mock_app(&builder)
        @app = Rack::Builder.new(&builder)
      end

      def app
        @app
      end

      def io_to_queue(io)
        io.rewind
        io.readlines.map { |line| JSON.parse line }
      end
    end
  end
end
