module GovukNavigationHelpers
  # Simple wrapper around a content store representation of a content item. Works
  # for both the main content item and the expanded links in the links hash.
  #
  # @private
  class ContentItem
    attr_reader :content_store_response

    def initialize(content_store_response)
      @content_store_response = content_store_response.to_h
    end

    def parent
      parent_item = content_store_response.dig("links", "parent", 0)
      return unless parent_item
      ContentItem.new(parent_item)
    end

    def parent_taxon
      # TODO: Determine what to do when there are multiple taxons/parents. For now just display the first of each.
      taxon = content_store_response.dig("links", "taxons", 0)
      return ContentItem.new(taxon) if taxon

      parent_taxon = content_store_response.dig("links", "parent_taxons", 0)
      return ContentItem.new(parent_taxon) if parent_taxon
    end

    def mainstream_browse_pages
      content_store_response.dig("links", "mainstream_browse_pages").to_a.map do |link|
        ContentItem.new(link)
      end
    end

    def title
      content_store_response.fetch("title")
    end

    def base_path
      content_store_response.fetch("base_path")
    end

    def content_id
      content_store_response.fetch("content_id")
    end

    def related_links
      content_store_response.dig("links", "ordered_related_items").to_a.map do |link|
        ContentItem.new(link)
      end
    end

    def external_links
      content_store_response.dig("details", "external_related_links").to_a
    end
  end
end
