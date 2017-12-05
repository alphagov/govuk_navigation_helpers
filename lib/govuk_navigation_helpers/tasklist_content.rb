module GovukNavigationHelpers
  class TasklistContent
    def self.learn_to_drive_config
      new.parse_file("learn-to-drive-a-car.json")
    end

    def parse_file(file)
      @file ||=
        JSON.parse(
          File.read(
            File.join(File.dirname(__FILE__), "../../", "config", "tasklists", file)
          )
        ).deep_symbolize_keys
    end
  end
end
