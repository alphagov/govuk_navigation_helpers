module GovukNavigationHelpers
  class TasklistContent
    def self.learn_to_drive_config
      @current = new.parse_file("learn-to-drive-a-car.json")
    end

    def self.get_a_divorce_config
      @current = new.parse_file("get-a-divorce.json")
    end

    def self.current
      @current
    end

    def self.primary_content
      if current
        current.dig(:tasklist, :groups).flat_map { |group|
          group.first[:contents].select { |content| content[:links] }
        }.flat_map { |hash| hash[:links] }
      end
    end

    def self.primary_links
      if current
        primary_content.map { |content| content[:href] }
      end
    end

    def parse_file(file)
      @file ||=
        JSON.parse(
          File.read(
            File.join(File.dirname(__FILE__), "../../", "config", "tasklists", file)
          )
        ).deep_symbolize_keys.tap do |json_file|
          json_file[:tasklist].merge!({small: true, heading_level: 3})
        end
    end
  end
end
