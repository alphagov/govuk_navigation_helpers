require "govuk_navigation_helpers/version"
require "govuk_navigation_helpers/breadcrumbs"
require "govuk_navigation_helpers/related_items"
require "govuk_navigation_helpers/taxon_breadcrumbs"
require "govuk_navigation_helpers/taxonomy_sidebar"
require "govuk_navigation_helpers/rummager_taxonomy_sidebar_links"
require "govuk_navigation_helpers/curated_taxonomy_sidebar_links"

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
      if show_taxonomy_navigation?
        TaxonBreadcrumbs.new(content_item).breadcrumbs
      else
        Breadcrumbs.new(content_item).breadcrumbs
      end
    end

    # Generate a related items payload
    #
    # @return [Hash] Payload for the GOV.UK Component
    # @see http://govuk-component-guide.herokuapp.com/components/related_items
    def related_items
      if show_taxonomy_navigation?
        TaxonomySidebar.new(content_item).sidebar
      else
        RelatedItems.new(content_item).related_items
      end
    end

  private

    def show_taxonomy_navigation?
      content_is_tagged_to_a_taxon? && !content_is_tagged_to_mainstream_browse?
    end

    def content_is_tagged_to_mainstream_browse?
      # TODO: What determines that something is in mainstream browse?
      false
    end

    def content_is_tagged_to_a_taxon?
      content_item.dig("links", "taxons").present?
    end

    attr_reader :content_item
  end
end
