require 'spec_helper'
require 'webmock/rspec'
require 'gds_api/test_helpers/rummager'

include GdsApi::TestHelpers::Rummager

RSpec.describe GovukNavigationHelpers::TaxonomySidebar do
  describe '#sidebar' do
    before(:each) do
      stub_any_rummager_search
        .to_return(
          body: {
            'results': [
              {
                'title': 'Result Content',
                'link': '/result-content',
              },
            ],
          }.to_json
        )
    end

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

    context 'given a content item tagged to taxons' do
      it 'returns a sidebar hash containing a list of parent taxons and related content' do
        content_item = content_item_tagged_to_taxon

        expect(sidebar_for(content_item)).to eq(
          items: [
            {
              title: "Taxon 1",
              url: "/taxon-1",
              description: "The 1st taxon.",
              related_content: [
                {
                  title: 'Result Content',
                  link: '/result-content',
                },
              ],
            },
            {
              title: "Taxon 2",
              url: "/taxon-2",
              description: "The 2nd taxon.",
              related_content: [
                {
                  title: 'Result Content',
                  link: '/result-content',
                },
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
            "title" => "Taxon 1",
            "base_path" => "/taxon-1",
            "content_id" => "taxon1",
            "description" => "The 1st taxon.",
          },
          {
            "title" => "Taxon 2",
            "base_path" => "/taxon-2",
            "content_id" => "taxon2",
            "description" => "The 2nd taxon.",
          },
        ],
      },
    }
  end
end
