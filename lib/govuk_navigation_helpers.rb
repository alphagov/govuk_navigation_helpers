require "govuk_navigation_helpers/version"
require "govuk_navigation_helpers/breadcrumbs"
require "govuk_navigation_helpers/related_items"

module GovukNavigationHelpers
  class NavigationHelper
    def initialize(content_item)
      @content_item = content_item
    end

    # Generate a breacrumb trail
    #
    # @return [Hash] Payload for the GOV.UK breadcrumbs component
    # @see http://govuk-component-guide.herokuapp.com/components/breadcrumbs
    def breadcrumbs
      Breadcrumbs.new(content_item).breadcrumbs
    end

    # Generate a related items payload
    #
    # @return [Hash] Payload for the GOV.UK Component
    # @see http://govuk-component-guide.herokuapp.com/components/related_items
    def related_items
      RelatedItems.new(content_item).related_items
    end

  private

    attr_reader :content_item
  end
end
