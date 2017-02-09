require 'spec_helper'

RSpec.describe GovukNavigationHelpers::Breadcrumbs do
  describe "#breadcrumbs" do
    it "can handle any valid content item" do
      generator = GovukSchemas::RandomExample.for_schema("placeholder", schema_type: "frontend")

      expect { GovukNavigationHelpers::Breadcrumbs.from_content_store_response(generator.payload).breadcrumbs }.to_not raise_error
    end

    it "returns the root when parent is not specified" do
      content_item = { "links" => {} }
      breadcrumbs = breadcrumbs_for(content_item)

      expect(breadcrumbs).to eq(
        breadcrumbs: [
          { title: "Home", url: "/" },
        ]
      )
    end

    it "returns the root when parent is empty" do
      content_item = content_item_with_parents([])
      breadcrumbs = breadcrumbs_for(content_item)

      expect(breadcrumbs).to eq(
        breadcrumbs: [
          { title: "Home", url: "/" },
        ]
      )
    end

    it "places parent under the root when there is a parent" do
      parent = {
        "content_id" => "30c1b93d-2553-47c9-bc3c-fc5b513ecc32",
        "locale" => "en",
        "title" => "A-parent",
        "base_path" => "/a-parent",
      }

      content_item = content_item_with_parents([parent])
      breadcrumbs = breadcrumbs_for(content_item)

      expect(breadcrumbs).to eq(
        breadcrumbs: [
          { title: "Home", url: "/" },
          { title: "A-parent", url: "/a-parent" }
        ]
      )
    end

    it "includes grandparent when available" do
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
          "parent" => [grandparent]
        }
      }

      content_item = content_item_with_parents([parent])
      breadcrumbs = breadcrumbs_for(content_item)

      expect(breadcrumbs).to eq(
        breadcrumbs: [
          { title: "Home", url: "/" },
          { title: "Another-parent", url: "/another-parent" },
          { title: "A-parent", url: "/a-parent" }
        ]
      )
    end
  end

  def content_item_with_parents(parents)
    {
      "links" => { "parent" => parents }
    }
  end

  def breadcrumbs_for(content_item)
    generator = GovukSchemas::RandomExample.for_schema("placeholder", schema_type: "frontend")
    fully_valid_content_item = generator.merge_and_validate(content_item)

    # Use the main class instead of GovukNavigationHelpers::Breadcrumbs, so that
    # we're testing both at the same time.
    GovukNavigationHelpers::NavigationHelper.new(fully_valid_content_item).breadcrumbs
  end
end
