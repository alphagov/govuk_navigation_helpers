module GovukNavigationHelpers
  # Wrapper around a publishing api representation of the expanded links.
  #
  # @private
  class PublishingApiLinkedEdition
    attr_reader :title, :base_path, :content_id

    def initialize(title:, base_path:, content_id:, links: {})
      @links = links
      @title = title
      @base_path = base_path
      @content_id = content_id
    end

    def self.from_nested_item(nested_item)
      new(
        title: nested_item["title"],
        base_path: nested_item["base_path"],
        content_id: nested_item["content_id"],
        links: nested_item["links"]
      )
    end

    def self.from_expanded_links_response(base_path:, title:, expanded_links_response:)
      new(
        title: title,
        base_path: base_path,
        content_id: expanded_links_response["content_id"],
        links: expanded_links_response["expanded_links"]
      )
    end

    def parent
      parent_item = expanded_links.dig("links", "parent", 0)
      return unless parent_item
      PublishingApiLinkedEdition.from_nested_item(parent_item)
    end

    def parent_taxon
      # TODO: Determine what to do when there are multiple parents. For now just display the first
      parent_taxon = links.dig("parent_taxons", 0)
      return unless parent_taxon
      PublishingApiLinkedEdition.from_nested_item(parent_taxon)
    end

    def mainstream_browse_pages
      links.dig("mainstream_browse_pages").to_a.map do |link|
        PublishingApiLinkedEdition.from_nested_item(link)
      end
    end

    def related_links
      links.dig("ordered_related_items").to_a.map do |link|
        PublishingApiLinkedEdition.from_nested_item(link)
      end
    end

  private

    attr_reader :links
  end
end
