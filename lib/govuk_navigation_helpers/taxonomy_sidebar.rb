require 'govuk_navigation_helpers/services'
require 'govuk_navigation_helpers/configuration'

module GovukNavigationHelpers
  class TaxonomySidebar
    def initialize(content_item)
      @content_item = ContentItem.new(content_item)
    end

    def sidebar
      items = taxons_with_related_links
        .concat(elsewhere_on_govuk)
        .concat(elsewhere_on_the_web)

      {
        items: items
      }
    end

  private

    def statsd
      GovukNavigationHelpers.configuration.statsd
    end

    def taxons_with_related_links
      parent_taxons = @content_item.parent_taxons

      parent_taxons.each_with_index.map do |parent_taxon, index|
        related_content = related_content_for_taxon(
          taxon: parent_taxon,
          show_search_related_links: index < 2
        )

        {
          title: parent_taxon.title,
          url: parent_taxon.base_path,
          description: parent_taxon.description,
          related_content: related_content,
        }
      end
    end

    def related_content_for_taxon(taxon:, show_search_related_links:)
      curated_related_links = @content_item.curated_related_links_for_taxon(taxon)

      if curated_related_links.empty?
        return [] if !show_search_related_links
        return search_related_links_tagged_to(taxon)
      end

      curated_related_links.map do |curated_related_link|
        {
          title: curated_related_link.title,
          link: curated_related_link.base_path
        }
      end
    end

    def elsewhere_on_govuk
      return [] if @content_item.curated_related_links_elsewhere_on_govuk.empty?

      related_content =
        @content_item.curated_related_links_elsewhere_on_govuk.map do |override|
          {
            title: override.title,
            link: override.base_path
          }
        end

      [
        {
          title: "Elsewhere on GOV.UK",
          related_content: related_content
        }
      ]
    end

    def elsewhere_on_the_web
      return [] if @content_item.external_links.empty?

      related_content = @content_item.external_links.map do |external_link|
        {
          title: external_link.fetch('title'),
          link: external_link.fetch('url'),
          rel: 'external'
        }
      end

      [
        {
          title: "Elsewhere on the web",
          related_content: related_content
        }
      ]
    end

    # This method will fetch content related to @content_item, and tagged to
    # taxon. This is a temporary method that uses search to achieve this. This
    # behaviour is to be moved into the content store.
    def search_related_links_tagged_to(taxon)
      statsd.time(:taxonomy_sidebar_search_time) do
        begin
          results = Services.rummager.search(
            similar_to: @content_item.base_path,
            start: 0,
            count: 3,
            filter_taxons: [taxon.content_id],
            filter_navigation_document_supertype: 'guidance',
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
