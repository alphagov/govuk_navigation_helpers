require 'govuk_navigation_helpers/grouped_related_links'
require 'govuk_navigation_helpers/content_item'

module GovukNavigationHelpers
  # Generate data for the "Related Items" component
  #
  # http://govuk-component-guide.herokuapp.com/components/related_items
  #
  # The procedure to group the links is quite complicated. In short, related links
  # are grouped by how related they are to the current page.
  #
  # The wiki page on related items has more information:
  #
  # https://gov-uk.atlassian.net/wiki/pages/viewpage.action?pageId=99876878
  class RelatedItems
    def initialize(content_item)
      @content_item = ContentItem.new(content_item)
    end

    def related_items
      {
        sections: [
          with_parent_in_common_section,
          with_grandparent_in_common_section,
          elsewhere_on_govuk_section,
          related_external_links_section,
        ].compact
      }
    end

  private

    attr_reader :content_item

    def with_parent_in_common_section
      return unless grouped.related_with_parent_in_common.any?

      items = grouped.related_with_parent_in_common.map do |related_item|
        {
          title: related_item.title,
          url: related_item.base_path
        }
      end

      { title: content_item.parent.title, items: items }
    end

    def with_grandparent_in_common_section
      return unless grouped.related_with_grandparent_in_common.any?

      items = grouped.related_with_grandparent_in_common.map do |related_item|
        {
          title: related_item.title,
          url: related_item.base_path
        }
      end

      { title: content_item.parent.parent.title, items: items }
    end

    def elsewhere_on_govuk_section
      return unless grouped.related_with_no_parents_in_common.any?

      items = grouped.related_with_no_parents_in_common.map do |related_item|
        {
          title: related_item.title,
          url: related_item.base_path
        }
      end

      { title: "Elsewhere on GOV.UK", items: items }
    end

    def related_external_links_section
      return unless content_item.external_links.any?

      items = content_item.external_links.map do |h|
        {
          title: h.fetch("title"),
          url: h.fetch("url"),
          rel: "external"
        }
      end

      { title: "Elsewhere on the web", items: items }
    end

    def grouped
      @grouped ||= GroupedRelatedLinks.new(content_item)
    end
  end
end
