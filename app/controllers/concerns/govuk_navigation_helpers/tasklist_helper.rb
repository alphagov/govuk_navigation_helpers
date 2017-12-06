module GovukNavigationHelpers
  module TasklistHelper
    def self.included(base)
      base.helper_method(
        :show_tasklist_header?,
        :show_tasklist_sidebar?,
      )
    end

    def show_tasklist_header?
      if defined?(should_show_tasklist_header?)
        should_show_tasklist_header?
      end
    end

    def show_tasklist_sidebar?
      if defined?(should_show_tasklist_sidebar?)
        should_show_tasklist_sidebar?
      end
    end

    def configure_current_task(config)
      tasklist = config[:tasklist]

      config[:tasklist] = set_task_as_active_if_current_page(tasklist)

      config
    end

    def set_task_as_active_if_current_page(tasklist)
      counter = 0
      tasklist[:groups].each do |grouped_steps|
        grouped_steps.each do |step|
          counter = counter + 1

          step[:contents].each do |link|
            if link[:href] == request.path
              link[:active] = true
              tasklist[:open_step] = counter
              return tasklist
            end
          end
        end
      end
      tasklist
    end

    def is_page_included_in_ab_test?
      GovukNavigationHelpers::TasklistPages::PRIMARY_PAGES.include?(request.path) ||
        GovukNavigationHelpers::TasklistPages::SECONDARY_PAGES.include?(request.path) ||
        GovukNavigationHelpers::TasklistPages::MATCHING_PAGES.include?(request.path)
    end
  end
end
