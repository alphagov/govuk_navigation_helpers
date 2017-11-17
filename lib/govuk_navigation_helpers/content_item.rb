module GovukNavigationHelpers
  # Simple wrapper around a content store representation of a content item.
  # Works for both the main content item and the expanded links in the links
  # hash.
  #
  # @private
  class ContentItem
    WORLD_TAXON_CONTENT_ID = "91b8ef20-74e7-4552-880c-50e6d73c2ff9".freeze
    EDUCATION_TAXON_CONTENT_ID = "c58fdadd-7743-46d6-9629-90bb3ccc4ef0".freeze
    CHILDCARE_PARENTING_TAXON_CONTENT_ID = "206b7f3a-49b5-476f-af0f-fd27e2a68473".freeze

    def self.whitelisted_root_taxon_content_ids
      [
        WORLD_TAXON_CONTENT_ID,
        EDUCATION_TAXON_CONTENT_ID,
        CHILDCARE_PARENTING_TAXON_CONTENT_ID,
      ]
    end

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
      @_parent_taxons ||= begin
        taxon_links
          .select { |t| descendent_from_whitelisted_root_taxon?(t) }
          .map { |taxon| ContentItem.new(taxon) }.sort_by(&:title)
      end
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

    def curated_taxonomy_sidebar_links
      content_store_response.dig("links", "ordered_related_items_overrides").to_a.map do |link|
        ContentItem.new(link)
      end
    end

    def external_links
      content_store_response.dig("details", "external_related_links").to_a
    end

    def as_taxonomy_sidebar_link
      {
        title: title,
        link: base_path,
      }
    end

    def ==(other)
      content_id == other.content_id
    end

    def hash
      content_id.hash
    end

    def eql?(other)
      self == other
    end

  private

    def taxon_links
      # A normal content item's taxon links are stored in ["links"]["taxons"]
      # whereas a Taxon content item's taxon links are stored in ["links"]["parent_taxons"]
      # so here we cater for both possibilities
      content_store_response.dig("links", "taxons") || content_store_response.dig("links", "parent_taxons") || []
    end

    def descendent_from_whitelisted_root_taxon?(taxon)
      root_taxon = get_root_taxon(taxon)
      ContentItem.whitelisted_root_taxon_content_ids.include?(root_taxon["content_id"])
    end

    def get_root_taxon(taxon)
      parent_taxons = taxon.dig("links", "parent_taxons")

      if parent_taxons.nil? || parent_taxons.empty?
        taxon
      else
        get_root_taxon(parent_taxons.first)
      end
    end
  end
end
