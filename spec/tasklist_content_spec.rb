require 'spec_helper'

module GovukNavigationHelpers
  RSpec.describe TasklistContent do
    context "learning to drive a car tasklist" do
      before do
        @config = described_class.learn_to_drive_config
      end

      it "configures a sidebar" do
        expect(@config[:tasklist][:heading_level]).to eql(3)
        expect(@config[:tasklist][:small]).to be true
      end

      it "has symbolized keys" do
        @config.keys.each do |key|
          expect(key.is_a?(Symbol)).to be true
        end
      end

      it "has a link in the correct structure" do
        first_link = @config[:tasklist][:groups][0][0][:contents][1][:links][0]
        expect(first_link[:href]).to eql("/vehicles-can-drive")
        expect(first_link[:text]).to eql("Check what age you can drive")
      end
    end

    context "get a divorce tasklist" do
      before do
        @config = described_class.get_a_divorce_config
      end

      it "configures a sidebar" do
        expect(@config[:tasklist][:heading_level]).to eql(3)
        expect(@config[:tasklist][:small]).to be true
      end

      it "has symbolized keys" do
        @config.keys.each do |key|
          expect(key.is_a?(Symbol)).to be true
        end
      end

      it "has a link in the correct structure" do
        first_link = @config[:tasklist][:groups][0][0][:contents][1][:links][0]
        expect(first_link[:href]).to eql("https://www.relate.org.uk/relationship-help/help-separation-and-divorce")
        expect(first_link[:text]).to eql("Get advice from Relate")
      end
    end
  end
end
