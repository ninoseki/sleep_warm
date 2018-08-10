module Rack
  class HuntUp < BaseUp
    attr_reader :app
    attr_reader :hunter
    attr_accessor :logger

    # @param [#call] app
    # @param [Proc] instance_configure
    def initialize(app)
      @app = app
      @hunter = SleepWarm::Hunter.new
      @logger = self.class.config.logger
      yield(self) if block_given?

      startup_info
    end

    class << self
      # Returns a configuration
      #
      # @param [Proc] global_configure
      # return [Rack::HuntUp::Configuration]
      def config
        @__config ||= Rack::HuntUp::Configuration.default
        yield(@__config) if block_given?
        @__config
      end
    end

    # @param  [Hash{String => String}] env
    # @return [Array(Integer, Hash, #each)]
    # @see    http://rack.rubyforge.org/doc/SPEC.html
    def call(env)
      req = Rack::Request.new(env)

      hits = hunter.hunt(request_info(req))
      logger.info(hunting_info(req, hits)) if hits

      @app.call(env)
    end

    private

    def startup_info
      STDOUT.puts "#{hunter.rules.length} hunting rule(s) loaded"
    end

    # Returns a hunting information for logging.
    #
    # @param [Rack::Request] req
    # @param [Array<String>] hits
    # @return [Hash]
    def hunting_info(req, hits)
      info = {
        client_ip: req.env["REMOTE_ADDR"],
        hits: hits.join(","),
        type: "sleep-warm-hunting"
      }
      info[:message] = "#{info[:client_ip]} #{info[:hits]}"

      info
    end
  end
end
