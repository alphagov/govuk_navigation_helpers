require "govuk_navigation_helpers/version"
require "govuk_navigation_helpers/breadcrumbs"
require "govuk_navigation_helpers/related_items"
require "govuk_navigation_helpers/taxon_breadcrumbs"
require "govuk_navigation_helpers/taxonomy_sidebar"
require "govuk_navigation_helpers/related_navigation_sidebar"
require "govuk_navigation_helpers/rummager_taxonomy_sidebar_links"
require "govuk_navigation_helpers/curated_taxonomy_sidebar_links"
require "govuk_navigation_helpers/tasklist_content"

require "govuk_navigation_helpers/concerns/tasklist_pages"
require "govuk_navigation_helpers/concerns/tasklist_ab_testable"
require "govuk_navigation_helpers/concerns/tasklist_header_ab_testable"

module GovukNavigationHelpers
  class NavigationHelper
    def initialize(content_item)
      @content_item = content_item
    end

    # Generate a breadcrumb trail
    #
    # @return [Hash] Payload for the GOV.UK breadcrumbs component
    # @see http://govuk-component-guide.herokuapp.com/components/breadcrumbs
    def breadcrumbs
      Breadcrumbs.new(content_item).breadcrumbs
    end

    # Generate a breadcrumb trail for a taxon, using the taxon_parent link field
    #
    # @return [Hash] Payload for the GOV.UK breadcrumbs component
    # @see http://govuk-component-guide.herokuapp.com/components/breadcrumbs
    def taxon_breadcrumbs
      TaxonBreadcrumbs.new(content_item).breadcrumbs
    end

    # Generate a payload containing taxon sidebar data. Intended for use with
    # the related items component.
    #
    # @return [Hash] Payload for the GOV.UK related items component
    # @see http://govuk-component-guide.herokuapp.com/components/related_items
    def taxonomy_sidebar
      TaxonomySidebar.new(content_item).sidebar
    end

    # Generate a related items payload
    #
    # @return [Hash] Payload for the GOV.UK Component
    # @see http://govuk-component-guide.herokuapp.com/components/related_items
    def related_items
      RelatedItems.new(content_item).related_items
    end

    # Generate a payload containing related navigation sidebar data. Intended for use with
    # the related navigation component
    #
    # @return [Hash] Payload for the GOV.UK related navigation component
    # @see https://government-frontend.herokuapp.com/component-guide/related-navigation
    def related_navigation_sidebar
      RelatedNavigationSidebar.new(content_item).related_navigation_sidebar
    end

  private

    attr_reader :content_item
  end
end
