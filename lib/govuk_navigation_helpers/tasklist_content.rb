module GovukNavigationHelpers
  class TasklistContent
    def initialize(file_name)
      @file_name = file_name
    end

    def tasklist
      parsed_file.dig(:tasklist)
    end

    def primary_content
      tasklist.dig(:groups).flat_map { |groups|
        groups.flat_map { |group|
          group[:contents].select { |content| content[:links] }
        }
      }.flat_map { |hash| hash[:links] }
    end

    def primary_paths
      primary_content.map do |content|
        content[:href] unless content[:href].start_with?('http')
      end.select(&:present?)
    end

    def related_paths
      parsed_file.dig(:related_paths)
    end

  private
    attr_reader :file_name, :file

    def parsed_file
      @parsed_file ||=
        JSON.parse(
          File.read(
            File.join(File.dirname(__FILE__), "../../", "config", "tasklists", "#{file_name}.json")
          )
        ).deep_symbolize_keys.tap do |json_file|
          json_file[:tasklist].merge!({small: true, heading_level: 3})
        end
    end
  end
end
