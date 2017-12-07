module GovukNavigationHelpers
  class TasklistContent
    def self.learn_to_drive_config
      new.parse_file("learn-to-drive-a-car.json")
    end

    def self.get_a_divorce_config
      new.parse_file("get-a-divorce.json")
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
