module Rack
  class HuntUp < BaseUp
    attr_reader :app
    attr_reader :hunter
    attr_accessor :logger

    # @param [#call] app
    # @param [Proc] instance_configure
    def initialize(app, &instance_configure)
      @app = app
      @hunter = SleepWarm::Hunter.new
      @logger = self.class.config.logger
      instance_configure.call(self) if block_given?

      bootstrap_logging
    end

    class << self
      # Returns a configuration
      #
      # @param [Proc] global_configure
      # return [Rack::HuntUp::Configuration]
      def config(&global_configure)
        @__config ||= Rack::HuntUp::Configuration.default
        global_configure.call(@__config) if block_given?
        @__config
      end
    end

    # @param  [Hash{String => String}] env
    # @return [Array(Integer, Hash, #each)]
    # @see    http://rack.rubyforge.org/doc/SPEC.html
    def call(env)
      req = Rack::Request.new(env)

      hits = hunter.hunt(request_info(req))
      logger.tagged("hunting") { logger.info(hunting_info(req, hits)) } if hits

      @app.call(env)
    end

    private

    # Logs to the application log
    def bootstrap_logging
      logger.tagged("application") { logger.info "#{hunter.rules.length} hunting rule(s) loaded" }
    end

    # Returns a hunting information for logging.
    #
    # @param [Rack::Request] req
    # @param [Array<String>] hits
    # @return [Hash]
    def hunting_info(req, hits)
      {
        client_ip: req.env["REMOTE_ADDR"],
        hits: hits.join(",")
      }
    end
  end
end
