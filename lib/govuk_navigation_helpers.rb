require "govuk_navigation_helpers/version"

module GovukNavigationHelpers
  class NavigationHelper
    def initialize(content_item)
      @content_item = content_item
    end

    # Generate a breacrumb trail
    #
    # @return [Array<Hash>] Each item is a hash containing `:title` and `:url` for one link in the breadcrumb
    def breadcrumbs
      direct_parent = content_item.dig("links", "parent", 0)

      ordered_parents = []

      while direct_parent
        ordered_parents << {
          title: direct_parent["title"],
          url: direct_parent["base_path"],
        }

        direct_parent = direct_parent.dig("links", "parent", 0)
      end

      ordered_parents << { title: "Home", url: "/" }

      ordered_parents.reverse
    end

  private

    attr_reader :content_item
  end
end
