require 'govuk_navigation_helpers/services'
require 'govuk_navigation_helpers/guidance'
require 'govuk_navigation_helpers/configuration'

module GovukNavigationHelpers
  class TaxonomySidebar
    def initialize(content_item)
      @content_item = ContentItem.new content_item
    end

    def sidebar
      {
        sections: taxons.any? ? [{ title: "More about #{@content_item.title}", items: taxons }] : []
      }
    end

  private

    def taxons
      parent_taxons = @content_item.parent_taxons
      parent_taxons.map do |parent_taxon|
        {
          title: parent_taxon.title,
          url: parent_taxon.base_path,
          description: parent_taxon.description,
          related_content: content_related_to(parent_taxon),
        }
      end
    end

    # This method will fetch content related to @content_item, and tagged to taxon. This is a
    # temporary method that uses search to achieve this. This behaviour is to be moved into
    # the content store
    def content_related_to(taxon)
      begin
        results = Services.rummager.search(
          similar_to: @content_item.base_path,
          start: 0,
          count: 5,
          filter_taxons: [taxon.content_id],
          filter_content_store_document_type: Guidance::DOCUMENT_TYPES,
          fields: %w[title link],
        )['results']

        results.map do |result|
          {
            title: result['title'],
            link: result['link'],
          }
        end
      rescue StandardError => e
        GovukNavigationHelpers.configuration.error_handler.notify(e)
        []
      end
    end
  end
end
