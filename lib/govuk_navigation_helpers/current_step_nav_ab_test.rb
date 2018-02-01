module GovukNavigationHelpers
  class CurrentStepNavAbTest
    TASKLIST_HEADER_DIMENSION = 44
    TASKLIST_SIDEBAR_DIMENSION = 66

    def initialize(current_step_nav:, request:)
      @current_step_nav = current_step_nav
      @ab_test_prefix = current_step_nav.ab_test_prefix if current_step_nav
      @request = request
    end

    def eligible?
      !! current_step_nav
    end

    def header
      @header ||= set_ab_test(
        name: "#{ab_test_prefix}TaskListHeader",
        dimension: TASKLIST_HEADER_DIMENSION
      )
    end

    def sidebar
      @sidebar ||= set_ab_test(
        name: "#{ab_test_prefix}TaskListSidebar",
        dimension: TASKLIST_SIDEBAR_DIMENSION
      )
    end

    def sidebar_variant
      @sidebar_variant ||=
        sidebar.requested_variant(request.headers)
    end

    def header_variant
      @header_variant ||=
        header.requested_variant(request.headers)
    end

    def show_step_nav_sidebar?
      sidebar_variant.variant?('B') && is_tested_page?
    end

    def show_step_nav_header?
      header_variant.variant?('B') && is_tested_page?
    end

    def is_tested_page?
      return current_step_nav.show_step_nav? if current_step_nav
    end

    def set_response_header(response)
      sidebar_variant.configure_response(response) if is_tested_page?
      header_variant.configure_response(response) if is_tested_page?
    end

  private

    attr_reader :current_step_nav, :ab_test_prefix, :request

    def set_ab_test(name:, dimension:)
      GovukAbTesting::AbTest.new(name, dimension: dimension)
    end
  end
end
