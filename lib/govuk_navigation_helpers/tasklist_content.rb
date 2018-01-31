module GovukNavigationHelpers
  class TasklistContent
    TASKLIST_NAMES = %w(
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

    def step_nav
      parsed_file.dig(:step_by_step_nav)
    end

    def ab_test_prefix
      parsed_file.dig(:ab_test_prefix)
    end

    def skip_link
      "##{steps.first[:title].downcase.tr(' ', '-')}"
    end

    def primary_paths
      primary_content.select { |href|
        !href.start_with?('http')
      }.select(&:present?)
    end

    def steps
      step_nav.dig(:steps)
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
      steps.each_with_index do |step, step_index|
        step[:contents].each do |content|
          next unless content[:contents]

          content[:contents].each do |link|
            if link[:href] == path
              link[:active] = true
              step_nav[:show_step] = step_index + 1
              step_nav[:highlight_group] = step_index + 1
              return step_nav
            end
          end
        end
      end

      step_nav
    end

    def primary_content
      list_content = steps.flat_map do |step|
        step[:contents].select { |item| item[:type] == "list" }
        .flat_map { |item| item[:contents] }
      end

      list_content.map { |list_item| list_item[:href] }
    end

    def parsed_file
      @parsed_file ||=
        JSON.parse(
          File.read(
            File.join(File.dirname(__FILE__), "../../", "config", "tasklists", "#{file_name}.json")
          )
        ).deep_symbolize_keys.tap do |json_file|
          json_file[:step_by_step_nav].merge!(small: true, heading_level: 3)
        end
    end
  end
end
