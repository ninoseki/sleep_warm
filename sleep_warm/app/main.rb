require "yaml"

module SleepWarm
  class Application

    def call(env)
      default = defaults.sample
      yaml = YAML.load_file(default)
      header = yaml.dig("response", "header")
      body = yaml.dig("response", "body")
      [200, header, [body]]
    end

    def defaults
      Dir.glob(File.expand_path("defaults/**/*.yml", __dir__))
    end
  end
end
