require 'govuk_navigation_helpers/services'
require 'govuk_navigation_helpers/guidance'
require 'govuk_navigation_helpers/configuration'

module GovukNavigationHelpers
  class TaxonomySidebar
    def initialize(content_item)
      @content_item = ContentItem.new content_item
    end

    def sidebar
      overriden = sidebar_from_overrides
      if overriden.empty?
        {
          items: taxons
        }
      else
        {
          items: overriden
        }
      end
    end

  private

    def sidebar_from_overrides
      overriden = @content_item.related_overrides
      taxons = {}
      grouped_overrides = {}

      overriden.each do |override|
        override_taxons = override.taxons

        taxon = override_taxons.find { |taxon| taxons.include?(taxon.content_id) }
        taxon ||= override_taxons.first

        taxons[taxon.content_id] = taxon
        grouped_overrides[taxon] ||= []
        grouped_overrides[taxon] << override
      end

      taxons.values.map do |taxon|
        related_content = grouped_overrides[taxon].map do |content_item|
          {
            title: content_item.title,
            link: content_item.base_path
          }
        end

        {
          title: taxon.title,
          url: taxon.base_path,
          related_content: related_content
        }
      end
    end

    def statsd
      GovukNavigationHelpers.configuration.statsd
    end

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
      statsd.time(:taxonomy_sidebar_search_time) do
        begin
          results = Services.rummager.search(
            similar_to: @content_item.base_path,
            start: 0,
            count: 3,
            filter_taxons: [taxon.content_id],
            filter_content_store_document_type: Guidance::DOCUMENT_TYPES,
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
