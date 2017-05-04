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
          register_to_vote_section,
          tagged_to_same_mainstream_browse_page_section,
          parents_tagged_to_same_mainstream_browse_page_section,
          tagged_to_different_mainstream_browse_pages_section,
          related_external_links_section,
        ].compact
      }
    end

  private

    attr_reader :content_item

    def register_to_vote_section
      return unless content_item.document_type == 'completed_transaction'
      return if content_item.base_path =~ /register-to-vote/

      {
        title: 'Register to vote',
        description: 'To vote in the General Election on 8 June, you need to apply to register by 11:59pm on 22 May.',
        url: nil,
        items: [
          title: 'Register to vote',
          url: '/register-to-vote'
        ]
      }
    end

    def tagged_to_same_mainstream_browse_page_section
      return unless grouped.tagged_to_same_mainstream_browse_page.any?

      items = grouped.tagged_to_same_mainstream_browse_page.map do |related_item|
        {
          title: related_item.title,
          url: related_item.base_path
        }
      end

      { title: content_item.parent.title, url: content_item.parent.base_path, items: items }
    end

    def parents_tagged_to_same_mainstream_browse_page_section
      return unless grouped.parents_tagged_to_same_mainstream_browse_page.any?

      items = grouped.parents_tagged_to_same_mainstream_browse_page.map do |related_item|
        {
          title: related_item.title,
          url: related_item.base_path
        }
      end

      { title: content_item.parent.parent.title, url: content_item.parent.parent.base_path, items: items }
    end

    def tagged_to_different_mainstream_browse_pages_section
      return unless grouped.tagged_to_different_mainstream_browse_pages.any?

      items = grouped.tagged_to_different_mainstream_browse_pages.map do |related_item|
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
