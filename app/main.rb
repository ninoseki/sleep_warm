require "yaml"

module SleepWarm
  class Application

    attr_reader :mrr

    def initialize
      @mrr = MRR.new
    end

    def call(env)
      req = Rack::Request.new(env)
      method = req.request_method
      uri = req.path
      header = req.env.to_s
      body = req.body
      # mrr.match?({
      #  method: method, uri: uri, header: header, body: body
      # })

      default = YAML.load_file(defaults.sample)
      header, body = parse(default)
      [200, header, [body]]
    end

    def parse(yaml)
      header = yaml.dig("response", "header")
      body = yaml.dig("response", "body")
      [header, body]
    end

    def defaults
      Dir.glob(File.expand_path("defaults/**/*.yml", __dir__))
    end
  end
end
