require 'govuk_navigation_helpers/services'
require 'govuk_navigation_helpers/configuration'

module GovukNavigationHelpers
  class RelatedNavigationSidebar
    def initialize(content_item)
      @content_item = ContentItem.new content_item
    end

    def related_navigation_sidebar
      {
        related_items: related_items,
        collections: related_collections,
        topics: related_topics,
        policies: related_policies,
        publishers: related_organisations,
        other: [related_external_links, related_contacts]
      }
    end

  private

    def build_links_for_sidebar(collection, path_key = "base_path", additional_attr = {})
      collection.map do |link|
        {
          text: link["title"],
          path: link[path_key]
        }.merge(additional_attr)
      end
    end

    def related_items
      quick_links = build_links_for_sidebar(@content_item.quick_links, "url")

      quick_links.any? ? quick_links : build_links_for_sidebar(@content_item.related_ordered_items)
    end

    def related_organisations
      build_links_for_sidebar(@content_item.related_organisations)
    end

    def related_collections
      build_links_for_sidebar(@content_item.related_collections)
    end

    def related_policies
      build_links_for_sidebar(@content_item.related_policies)
    end

    def related_topics
      build_links_for_sidebar(@content_item.related_topics)
    end

    def related_contacts
      return [] unless @content_item.related_other_contacts.any?
      [
        title: "Other contacts",
        links: build_links_for_sidebar(@content_item.related_other_contacts).map
      ]
    end

    def related_external_links
      return [] unless @content_item.external_links.any?
      [
        title: "Elsewhere on the web",
        links: build_links_for_sidebar(@content_item.external_links, "url", rel: 'external')
      ]
    end
  end
end
