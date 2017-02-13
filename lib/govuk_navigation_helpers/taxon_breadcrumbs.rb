module GovukNavigationHelpers
  class TaxonBreadcrumbs
    def initialize(content_item)
      @content_item = ContentItem.new(content_item)
    end

    def breadcrumbs
      ordered_parents = all_parents.map do |parent|
        { title: parent.title, url: parent.base_path }
      end

      ordered_parents << { title: "Home", url: "/" }

      ordered_breadcrumbs = ordered_parents.reverse
      ordered_breadcrumbs << { title: content_item.title, url: "#content" }

      {
        breadcrumbs: ordered_breadcrumbs
      }
    end

  private

    attr_reader :content_item

    def all_parents
      parents = []

      direct_parent = content_item.parent_taxon
      while direct_parent
        parents << direct_parent
        direct_parent = direct_parent.parent_taxon
      end

      parents
    end
  end
end
