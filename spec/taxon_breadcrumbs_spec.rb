require 'spec_helper'

RSpec.describe GovukNavigationHelpers::TaxonBreadcrumbs do
  describe "Taxon breadcrumbs" do
    it "can handle any valid content item" do
      generator = GovukSchemas::RandomExample.for_schema("taxon", schema_type: "frontend")

      expect { GovukNavigationHelpers::TaxonBreadcrumbs.new(generator.payload).breadcrumbs }.to_not raise_error
    end

    it "returns the root when taxon is not specified" do
      content_item = { "links" => {} }
      breadcrumbs = breadcrumbs_for(content_item)

      expect(breadcrumbs).to eq(
        breadcrumbs: [
          { title: "Home", url: "/" },
        ]
      )
    end

    it "places parent under the root when there is a taxon" do
      content_item = content_item_with_parents([])
      breadcrumbs = breadcrumbs_for(content_item)

      expect(breadcrumbs).to eq(
        breadcrumbs: [
          { title: "Home", url: "/" },
          { title: "Taxon", url: "/a-taxon" }
        ]
      )
    end

    it "includes parents and grandparents when available" do
      grandparent = {
          "title" => "Another-parent",
          "base_path" => "/another-parent",
          "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
          "locale" => "en",
      }

      parent = {
          "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
          "locale" => "en",
          "title" => "A-parent",
          "base_path" => "/a-parent",
          "links" => {
              "parent_taxons" => [grandparent]
          }
      }

      content_item = content_item_with_parents([parent])
      breadcrumbs = breadcrumbs_for(content_item)

      expect(breadcrumbs).to eq(
        breadcrumbs: [
          { title: "Home", url: "/" },
          { title: "Another-parent", url: "/another-parent" },
          { title: "A-parent", url: "/a-parent" },
          { title: "Taxon", url: "/a-taxon" },
        ]
      )
    end
  end

  def breadcrumbs_for(content_item)
    generator = GovukSchemas::RandomExample.for_schema("taxon", schema_type: "frontend")
    fully_valid_content_item = generator.merge_and_validate(content_item)

    # Use the main class instead of GovukNavigationHelpers::Breadcrumbs, so that
    # we're testing both at the same time.
    GovukNavigationHelpers::NavigationHelper.new(fully_valid_content_item).taxon_breadcrumbs
  end

  def content_item_with_parents(parents)
    {
      "links" => {
        "taxons" => [
          {
            "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
            "locale" => "en",
            "title" => "Taxon",
            "base_path" => "/a-taxon",
            "links" => {
              "parent_taxons" => parents
            },
          },
        ],
      },
    }
  end
end
