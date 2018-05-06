module Rack
  class HuntUp
    class Configuration
      attr_accessor :hunting_logger
      attr_accessor :application_logger

      def self.default
        new.tap do |config|
          config.hunting_logger = nil
          config.application_logger = nil
        end
      end
    end
  end
end
