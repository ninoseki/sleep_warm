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
      p uri
      p mrr.match?({
        method: method, uri: uri, header: header, body: body
      })

      default = YAML.load_file(defaults.sample)
      headers, body = parse(default)
      [200, headers, [body]]
    end

    def parse(yaml)
      headers = yaml.dig("response", "headers")
      body = yaml.dig("response", "body")
      [headers, body]
    end

    def defaults
      Dir.glob(File.expand_path("defaults/**/*.yml", __dir__))
    end
  end
end
