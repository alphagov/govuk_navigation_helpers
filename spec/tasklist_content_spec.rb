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

      it 'has all the primary paths' do
        primary_paths = %w(
          /apply-first-provisional-driving-licence
          /book-driving-test
          /book-theory-test
          /cancel-driving-test
          /cancel-theory-test
          /change-driving-test
          /change-theory-test
          /check-driving-test
          /check-theory-test
          /driving-eyesight-rules
          /driving-lessons-learning-to-drive
          /driving-test/what-to-take
          /find-driving-schools-and-lessons
          /government/publications/car-show-me-tell-me-vehicle-safety-questions
          /guidance/the-highway-code
          /legal-obligations-drivers-riders
          /pass-plus
          /take-practice-theory-test
          /theory-test/revision-and-practice
          /theory-test/what-to-take
          /vehicles-can-drive
        ).sort

        expect(
          described_class.primary_paths.sort
        ).to match_array(primary_paths)
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
