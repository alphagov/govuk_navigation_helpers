require 'spec_helper'

RSpec.describe GovukNavigationHelpers::TaxonSidebar do
  describe '#sidebar' do
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
          sections: []
        )
      end
    end

    context 'given a content item tagged to taxons' do
      it 'returns a sidebar hash containing a list of parent taxons' do
        content_item = content_item_tagged_to_taxon

        expect(sidebar_for(content_item)).to eq(
          sections: [
            {
              title: "More about",
              items: [
                { title: "Taxon 1", url: "/taxon-1" },
                { title: "Taxon 2", url: "/taxon-2" },
              ],
            }
          ]
        )
      end
    end
  end

  def sidebar_for(content_item)
    GovukNavigationHelpers::NavigationHelper.new(content_item).taxon_sidebar
  end

  def content_item_tagged_to_taxon
    {
      "title" => "A piece of content",
      "links" => {
        "taxons" => [
          {
            "title" => "Taxon 1",
            "base_path" => "/taxon-1",
          },
          {
            "title" => "Taxon 2",
            "base_path" => "/taxon-2",
          },
        ],
      },
    }
  end
end
