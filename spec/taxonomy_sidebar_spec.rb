require 'spec_helper'
require 'webmock/rspec'
require 'gds_api/test_helpers/rummager'

include GdsApi::TestHelpers::Rummager

RSpec.describe GovukNavigationHelpers::TaxonomySidebar do
  describe '#sidebar' do
    before { stub_any_rummager_search_to_return_no_results }

    it 'can handle any valid content item' do
      generator = GovukSchemas::RandomExample.for_schema(
        'placeholder',
        schema_type: 'frontend'
      )

      expect { sidebar_for(generator.payload) }.to_not raise_error
    end

    context 'given a content item not tagged to any taxon' do
      it 'returns an empty sidebar hash' do
        content_item = { "links" => {} }

        expect(sidebar_for(content_item)).to eq(
          items: []
        )
      end
    end

    context 'given a content item tagged to taxons and with related items' do
      before do
        stub_any_rummager_search
          .to_return(
            body: {
              'results': [
                { 'title': 'Related item C', 'link': '/related-item-c', },
                { 'title': 'Related item B', 'link': '/related-item-b', },
                { 'title': 'Related item A', 'link': '/related-item-a', },
              ],
            }.to_json
          )
      end

      it 'returns a sidebar hash containing a sorted list of parent taxons and related content' do
        expect(GovukNavigationHelpers.configuration.statsd).to receive(
          :increment
        ).with(
          :taxonomy_sidebar_searches
        ).twice

        content_item = content_item_tagged_to_taxon

        expect(sidebar_for(content_item)).to eq(
          items: [
            {
              title: "Taxon A",
              url: "/taxon-a",
              description: "The A taxon.",
              related_content: [
                { 'title': 'Related item A', 'link': '/related-item-a', },
                { 'title': 'Related item B', 'link': '/related-item-b', },
                { 'title': 'Related item C', 'link': '/related-item-c', },
              ],
            },
            {
              title: "Taxon B",
              url: "/taxon-b",
              description: "The B taxon.",
              related_content: [
                { 'title': 'Related item A', 'link': '/related-item-a', },
                { 'title': 'Related item B', 'link': '/related-item-b', },
                { 'title': 'Related item C', 'link': '/related-item-c', },
              ],
            },
          ]
        )
      end
    end

    context 'when Rummager raises an exception' do
      error_handler = nil

      before(:each) do
        stub_any_rummager_search
            .to_return(status: 500)

        error_handler = spy('error_handler')

        GovukNavigationHelpers.configure do |config|
          config.error_handler = error_handler
        end

        expect(GovukNavigationHelpers.configuration.statsd).to_not receive(
          :increment
        )
      end

      it 'does not re-raise' do
        content_item = content_item_tagged_to_taxon

        expect { sidebar_for(content_item) }.to_not raise_error
      end

      it 'logs an error' do
        content_item = content_item_tagged_to_taxon
        sidebar_for(content_item)

        expect(error_handler).to have_received(:notify).at_least(1).times
      end
    end
  end

  def sidebar_for(content_item)
    GovukNavigationHelpers::NavigationHelper.new(content_item).taxonomy_sidebar
  end

  def content_item_tagged_to_taxon
    {
      "title" => "A piece of content",
      "base_path" => "/a-piece-of-content",
      "links" => {
        "taxons" => [
          {
            "title" => "Taxon B",
            "base_path" => "/taxon-b",
            "content_id" => "taxon-b",
            "description" => "The B taxon.",
          },
          {
            "title" => "Taxon A",
            "base_path" => "/taxon-a",
            "content_id" => "taxon-a",
            "description" => "The A taxon.",
          },
        ],
      },
    }
  end
end
