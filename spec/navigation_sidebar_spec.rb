require "spec_helper"

RSpec.describe GovukNavigationHelpers::RelatedNavigationSidebar do
  def payload_for(schema, content_item)
    generator = GovukSchemas::RandomExample.for_schema(schema, schema_type: "frontend")
    fully_valid_content_item = generator.merge_and_validate(content_item)
    GovukNavigationHelpers::NavigationHelper.new(fully_valid_content_item).related_navigation_sidebar
  end

  describe "#related-navigation-sidebar" do
    it "can handle randomly generated content" do
      generator = GovukSchemas::RandomExample.for_schema("placeholder", schema_type: "frontend")

      expect { payload_for("placeholder", generator.payload) }.to_not raise_error
    end

    it "returns empty arrays if there are no related navigation sidebar links" do
      nothing = payload_for("placeholder",
        "details" => {
          "external_related_links" => []
        },
        "links" => {
        }
      )

      expected = {
        related_items: [],
        collections: [],
        topics: [],
        policies: [],
        publishers: [],
        other: [[], []]
      }

      expect(nothing).to eql(expected)
    end

    it "extracts and returns the appropriate related links" do
      payload = payload_for("speech",
        "details" => {
          "body" => "body",
          "government" => {
            "title" => "government",
            "slug" => "government",
            "current" => true
            },
          "political" => true,
          "delivered_on" => "2017-09-22T14:30:00+01:00"
        },
        "links" => {
          "ordered_related_items" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-item",
              "title" => "related item"
            }
          ],
          "document_collections" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-collection",
              "title" => "related collection",
              "document_type" => "document_collection"
            }
          ],
          "topics" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-topic",
              "title" => "related topic",
              "document_type" => "topic"
            }
          ],
          "organisations" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-organisation",
              "title" => "related organisation",
              "document_type" => "organisation"
            }
          ],
          "related_policies" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-policy",
              "title" => "related policy",
              "document_type" => "policy"
            }
          ]
        }
      )

      expected = {
        related_items: [{ path: "/related-item", text: "related item" }],
        collections: [{ path: "/related-collection", text: "related collection" }],
        topics: [{ path: "/related-topic", text: "related topic" }],
        policies: [{ path: "/related-policy", text: "related policy" }],
        publishers: [{ path: "/related-organisation", text: "related organisation" }],
        other: [[], []]
      }

      expect(payload).to eql(expected)
    end

    it "returns an Elsewhere on the web section for external related links" do
      payload = payload_for("placeholder",
        "details" => {
          "external_related_links" => [
            {
              "title" => "external-link",
              "url" => "https://external"
            }
          ]
        },
      )

      expected = [
        [
          {
            title: "Elsewhere on the web",
            links: [{
                text: "external-link",
                path: "https://external",
                rel: "external"
              }]
          }
        ],
        []
      ]

      expect(payload[:other]).to eql(expected)
    end
  end
end
