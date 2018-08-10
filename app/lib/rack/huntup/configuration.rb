module Rack
  class HuntUp
    class Configuration
      attr_accessor :logger

      def self.default
        new.tap do |config|
          config.logger = nil
        end
      end
    end
  end
end
