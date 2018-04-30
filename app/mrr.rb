require "yaml"

module SleepWarm
  class MRR
    def find(input = { method: nil, uri: nil, header: nil, body: nil })
      input = input.compact.map { |k, v| [k.to_s, v] }.to_h
      rules.find do |rule|
        trigger = rule.dig("trigger")
        next unless trigger
        trigger.all? do |k, v|
          input.dig(k) && input.dig(k).match?(v)
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
