module Rack
  class SpyUp
    class Configuration
      attr_accessor :access_logger
      attr_accessor :application_logger

      def self.default
        new.tap do |config|
          config.access_logger = nil
          config.application_logger = nil
        end
      end
    end
  end
end
