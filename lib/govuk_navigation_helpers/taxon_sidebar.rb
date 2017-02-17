module GovukNavigationHelpers
  class TaxonSidebar
    def initialize(content_item)
      @content_item = ContentItem.new content_item
    end

    def sidebar
      {
        sections: taxons.any? ? [{ title: "More about", items: taxons }] : []
      }
    end

  private

    def taxons
      parent_taxons = @content_item.parent_taxons
      parent_taxons.map do |parent_taxon|
        { title: parent_taxon.title, url: parent_taxon.base_path }
      end
    end
  end
end
