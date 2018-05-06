require "yaml"

module SleepWarm
  class Application

    def call(_)
      default = defaults.sample
      yaml = YAML.load_file(default)
      header = yaml.dig("response", "header")
      body = yaml.dig("response", "body")
      [200, header, [body]]
    end

    # Returns default paths of YAML for Rack::Response
    #
    # @return [Array<String>]
    def defaults
      Dir.glob(File.expand_path("defaults/**/*.yml", __dir__))
    end
  end
end
