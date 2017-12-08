module GovukNavigationHelpers
  class TasklistContent
    TASKLIST_NAMES = %w(
      get-a-divorce
      end-a-civil-partnership
      learn-to-drive-a-car
    ).freeze

    def self.current_tasklist(path)
      TASKLIST_NAMES.each do |tasklist_name|
        tasklist = new(file_name: tasklist_name, path: path)
        return tasklist if tasklist.current?
      end
      nil
    end

    def initialize(file_name: nil, path: nil)
      @file_name = file_name
      @path = path
    end

    def title
      parsed_file.dig(:title)
    end

    def base_path
      parsed_file.dig(:base_path)
    end

    def tasklist
      parsed_file.dig(:tasklist)
    end

    def ab_test_prefix
      parsed_file.dig(:ab_test_prefix)
    end

    def skip_link
      "##{groups.flatten.first[:title].downcase.tr(' ', '-')}"
    end

    def primary_paths
      primary_content.map { |content|
        content[:href] unless content[:href].start_with?('http')
      }.select(&:present?)
    end

    def groups
      tasklist.dig(:groups)
    end

    def related_paths
      parsed_file.dig(:related_paths)
    end

    def set_current_task
      set_task_as_active_if_current_page
    end

    def is_page_included_in_ab_test?
      primary_paths.include?(path) ||
        related_paths.include?(path)
    end

    def current?
      primary_paths.include?(path) ||
        related_paths.include?(path)
    end

  private

    attr_reader :file_name, :file, :path

    def set_task_as_active_if_current_page
      counter = 0

      groups.each do |grouped_steps|
        grouped_steps.each do |step|
          counter += 1

          step[:contents].each do |content|
            next unless content[:contents]

            content[:contents].each do |link|
              if link[:href] == path
                link[:active] = true
                tasklist[:show_step] = counter
                return tasklist
              end
            end
          end
        end
      end

      tasklist
    end

    def primary_content
      primary_content = groups.flat_map do |grouped_steps|
        grouped_steps.flat_map do |group|
          group[:contents].select { |content| content[:contents] }
        end
      end

      primary_content.flat_map { |hash| hash[:contents] }
    end

    def parsed_file
      @parsed_file ||=
        JSON.parse(
          File.read(
            File.join(File.dirname(__FILE__), "../../", "config", "tasklists", "#{file_name}.json")
          )
        ).deep_symbolize_keys.tap do |json_file|
          json_file[:tasklist].merge!(small: true, heading_level: 3)
        end
    end
  end
end
