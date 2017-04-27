require 'govuk_navigation_helpers/services'
require 'govuk_navigation_helpers/configuration'

module GovukNavigationHelpers
  class TaxonomySidebar
    def initialize(content_item)
      @content_item = ContentItem.new content_item
    end

    def sidebar
      {
        items: taxons
      }
    end

  private

    def statsd
      GovukNavigationHelpers.configuration.statsd
    end

    def taxons
      parent_taxons = @content_item.parent_taxons
      used_related_links = Set.new

      parent_taxons.each_with_index.map do |parent_taxon, index|
        related_content = index < 2 ? content_related_to(parent_taxon, used_related_links) : []

        used_related_links.merge(
          related_content.map { |content| content[:link] }
        )

        {
          title: parent_taxon.title,
          url: parent_taxon.base_path,
          description: parent_taxon.description,
          related_content: related_content,
        }
      end
    end

    # This method will fetch content related to @content_item, and tagged to taxon. This is a
    # temporary method that uses search to achieve this. This behaviour is to be moved into
    # the content store
    def content_related_to(taxon, used_related_links)
      statsd.time(:taxonomy_sidebar_search_time) do
        begin
          results = Services.rummager.search(
            similar_to: @content_item.base_path,
            start: 0,
            count: 3,
            filter_taxons: [taxon.content_id],
            filter_navigation_document_supertype: 'guidance',
            reject_link: used_related_links.to_a,
            fields: %w[title link],
          )['results']

          statsd.increment(:taxonomy_sidebar_searches)

          results
            .map { |result| { title: result['title'], link: result['link'], } }
            .sort_by { |result| result[:title] }
        rescue StandardError => e
          GovukNavigationHelpers.configuration.error_handler.notify(e)
          []
        end
      end
    end
  end
end
