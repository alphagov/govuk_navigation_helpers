module GovukNavigationHelpers
  module TasklistHelper
    def self.included(base)
      base.helper_method(
        :show_tasklist_header?,
        :show_tasklist_sidebar?,
      )
    end

    def current_tasklist_content(tasklist_content)
      @current_tasklist_content = tasklist_content
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

    def configure_current_task
      tasklist = @current_tasklist_content.tasklist

      set_task_as_active_if_current_page(tasklist)
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
      @current_tasklist_content.primary_paths.include?(request.path) ||
        @current_tasklist_content.related_paths.include?(request.path)
    end
  end
end
