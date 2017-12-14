module GovukNavigationHelpers
  class CurrentTasklistAbTest
    TASKLIST_HEADER_DIMENSION = 44
    TASKLIST_SIDEBAR_DIMENSION = 66
    PUBLICATION_PAGE = "/government/publications/car-show-me-tell-me-vehicle-safety-questions".freeze

    def initialize(current_tasklist:, request:)
      @current_tasklist = current_tasklist
      @ab_test_prefix = current_tasklist.ab_test_prefix if current_tasklist
      @request = request
    end

    def eligible?
      !! current_tasklist
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

    def show_tasklist_sidebar?
      sidebar_variant.variant?('B')
      true
    end

    def show_tasklist_header?
      header_variant.variant?('B')
      true
    end

    def set_response_header(response)
      sidebar_variant.configure_response(response) if show_tasklist_sidebar?
      header_variant.configure_response(response) if show_tasklist_header?
    end

    def publication_with_sidebar?
      show_tasklist_sidebar? && request.path == PUBLICATION_PAGE
    end

    def publication_with_sidebar_template_name
      "publication_with_tasklist_sidebar"
    end

  private

    attr_reader :current_tasklist, :ab_test_prefix, :request

    def set_ab_test(name:, dimension:)
      GovukAbTesting::AbTest.new(name, dimension: dimension)
    end
  end
end
