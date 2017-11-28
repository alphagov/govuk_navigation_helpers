require 'govuk_navigation_helpers/services'
require 'govuk_navigation_helpers/configuration'

module GovukNavigationHelpers
  class NavigationSidebar
    def initialize(content_item)
      @content_item = ContentItem.new content_item
    end

    def navigation_sidebar
      {
        related_items: related_items,
        collections: related_collections,
        topics: related_topics,
        policies: related_policies,
        publishers: related_organisations,
        external_links: related_external_links
      }
    end

  private

    def process_links_for_sidebar(related_content)
      related_content.map do |link|
        puts link
        {
          text: link["title"],
          path: link["base_path"]
        }
      end
    end

    def related_items
      process_links_for_sidebar(@content_item.navigation_sidebar_related_links)
    end

    def related_organisations
      process_links_for_sidebar(@content_item.related_organisations)
    end

    def related_collections
      process_links_for_sidebar(@content_item.related_collections)
    end

    def related_policies
      process_links_for_sidebar(@content_item.related_policies)
    end

    def related_topics
      process_links_for_sidebar(@content_item.related_topics)
    end

    def related_external_links
      @content_item.external_links.map do |link|
        {
          text: link["title"],
          path: link["url"]
        }
      end
    end
  end
end
