require "spec_helper"

RSpec.describe GovukNavigationHelpers::ContentItem do
  describe ".whitelisted_root_taxon_content_ids" do
    it "returns the whitelisted content_ids" do
      expected_content_ids = [
        "91b8ef20-74e7-4552-880c-50e6d73c2ff9",
        "c58fdadd-7743-46d6-9629-90bb3ccc4ef0",
        "206b7f3a-49b5-476f-af0f-fd27e2a68473",
      ]

      content_ids = described_class.whitelisted_root_taxon_content_ids
      expect(content_ids).to eq(expected_content_ids)
    end
  end

  describe "#parent_taxons" do
    context "for a content item with taxons links" do
      context "with a parent taxon with phase set to 'live'" do
        let(:taxon) do
          {
            "content_id" => "cccc-dddd",
            "title" => "Taxon",
            "phase" => "live",
            "links" => {
              "parent_taxons" => [
                {
                  "content_id" => "aaaa-bbbb",
                  "title" => "Taxon",
                }
              ]
            }
          }
        end

        let(:content_item_response) do
          {
            "title" => "Some Answer Content Item",
            "document_type" => "answer",
            "links" => {
              "taxons" => [taxon],
            }
          }
        end

        it "returns the parent taxons" do
          expected_parent_taxon = described_class.new(taxon)
          expect(described_class.new(content_item_response).parent_taxons).to contain_exactly(expected_parent_taxon)
        end
      end

      context "with a parent taxon with phase not set to 'live'" do
        let(:taxon) do
          {
            "content_id" => "cccc-dddd",
            "title" => "Taxon",
            "phase" => "beta",
            "links" => {
              "parent_taxons" => [
                {
                  "content_id" => "xxxx-xxxx",
                  "title" => "Non Whitelisted Taxon",
                }
              ]
            }
          }
        end

        let(:content_item_response) do
          {
            "title" => "Some Answer Content Item",
            "document_type" => "answer",
            "links" => {
              "taxons" => [taxon],
            }
          }
        end

        it "returns an empty array" do
          expect(described_class.new(content_item_response).parent_taxons).to eq([])
        end
      end
    end

    context "for a content item with no taxons links" do
      context "with missing links hash" do
        let(:content_item_response) do
          {
            "title" => "Some Answer Content Item",
            "document_type" => "answer",
          }
        end

        it "returns an empty array" do
          expect(described_class.new(content_item_response).parent_taxons).to eq([])
        end
      end

      context "with missing taxons links hash" do
        let(:content_item_response) do
          {
            "title" => "Some Answer Content Item",
            "document_type" => "answer",
            "links" => {},
          }
        end

        it "returns an empty array" do
          expect(described_class.new(content_item_response).parent_taxons).to eq([])
        end
      end
    end

    context "for a taxon content item with parent taxon links" do
      context "with a parent taxon with phase set to 'live'" do
        let(:taxon) do
          {
            "content_id" => "cccc-dddd",
            "title" => "Taxon",
            "phase" => "live",
            "links" => {
              "parent_taxons" => [
                {
                  "content_id" => "aaaa-bbbb",
                  "title" => "Taxon",
                }
              ]
            }
          }
        end

        let(:content_item_response) do
          {
            "title" => "Some Taxon Content Item",
            "document_type" => "taxon",
            "links" => {
              "parent_taxons" => [taxon],
            }
          }
        end

        it "returns the parent taxons" do
          expected_parent_taxon = described_class.new(taxon)
          expect(described_class.new(content_item_response).parent_taxons).to contain_exactly(expected_parent_taxon)
        end
      end

      context "with a parent taxon with phase not set to 'live'" do
        let(:taxon) do
          {
            "content_id" => "cccc-dddd",
            "title" => "Taxon",
            "phase" => "beta",
            "links" => {
              "parent_taxons" => [
                {
                  "content_id" => "xxxx-xxxx",
                  "title" => "Non Whitelisted Taxon",
                }
              ]
            }
          }
        end

        let(:content_item_response) do
          {
            "title" => "Some Taxon Content Item",
            "document_type" => "taxon",
            "links" => {
              "parent_taxons" => [taxon],
            }
          }
        end

        it "returns an empty array" do
          expect(described_class.new(content_item_response).parent_taxons).to eq([])
        end
      end
    end

    context "for a taxon content item with no parent taxons links" do
      context "with missing links hash" do
        let(:content_item_response) do
          {
            "title" => "Some Taxon Content Item",
            "document_type" => "taxon",
          }
        end

        it "returns an empty array" do
          expect(described_class.new(content_item_response).parent_taxons).to eq([])
        end
      end

      context "with missing parent taxons links hash" do
        let(:content_item_response) do
          {
            "title" => "Some Taxon Content Item",
            "document_type" => "taxon",
            "links" => {},
          }
        end

        it "returns an empty array" do
          expect(described_class.new(content_item_response).parent_taxons).to eq([])
        end
      end
    end
  end
end
