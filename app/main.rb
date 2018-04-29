require "yaml"

module SleepWarm
  class Application
    def call(env)
      template = YAML.load_file(templates.sample)
      headres = template.fetch(:headers).map { |k, v| [k.to_s, v] }.to_h
      body = template.fetch(:body)
      [200, headres, [body]]
    end

    def templates
      Dir.glob(File.expand_path("fixtures/**/*.yml", __dir__))
    end
  end
end
