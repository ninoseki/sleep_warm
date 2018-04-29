require "yaml"

module SleepWarm
  class MRR
    def match?(trigger = { method: nil, uri: nil, header: nil, body:nil })
      trigger = trigger.compact
      rules.find do |rule|
        trigger.all? do |k, v|
          rule.dig("trigger", k.to_s) && rule.dig("trigger", k.to_s).match?(v)
        end
      end
    end

    def rules
      @rules ||= Dir.glob(File.expand_path("rules/**/*.yml", __dir__)).map do |path|
        YAML.load_file path
      end
    end
  end
end
