module GovukNavigationHelpers
  # Simple wrapper around a content store representation of a content item.
  # Works for both the main content item and the expanded links in the links
  # hash.
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
      # TODO: Determine what to do when there are multiple taxons/parents. For
      # now just display the first of each.
      parent_taxons.sort_by(&:title).first
    end

    def parent_taxons
      # First handle the case for content items tagged to the taxonomy.
      taxons = Array(content_store_response.dig("links", "taxons"))
      return taxons.map { |taxon| ContentItem.new(taxon) }.sort_by(&:title) if taxons.any?

      # If that link isn't present, assume we're dealing with a taxon and check
      # for its parents in the taxonomy.
      parent_taxons = Array(content_store_response.dig("links", "parent_taxons"))
      parent_taxons.map { |taxon| ContentItem.new(taxon) }.sort_by(&:title)
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

    def description
      content_store_response.fetch("description", "")
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
