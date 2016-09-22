require "govuk_navigation_helpers/version"
require "govuk_navigation_helpers/breadcrumbs"

module GovukNavigationHelpers
  class NavigationHelper
    def initialize(content_item)
      @content_item = content_item
    end

    # Generate a breacrumb trail
    #
    # @return [Array<Hash>] Each item is a hash containing `:title` and `:url` for one link in the breadcrumb
    def breadcrumbs
      Breadcrumbs.new(content_item).breadcrumbs
    end

  private

    attr_reader :content_item
  end
end
