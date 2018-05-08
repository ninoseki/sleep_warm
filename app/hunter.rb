require 'yaml'

module SleepWarm
  class Hunter

    def hunt(input)
      selected = rules.map { |rule| input.match rule }.compact.map { |match| match[0] }
      selected.empty? ? nil : selected
    end

    def rules
      @rules ||= [].tap do |out|
        yaml = YAML.load_file File.expand_path("rules/hunt.yml", __dir__)
        if yaml.dig("meta", "enable")
          yaml.dig("rules").each { |rule| out << rule }
        end
      end
    end
  end
end
