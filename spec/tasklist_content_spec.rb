require 'spec_helper'

module GovukNavigationHelpers
  RSpec.describe TasklistContent do
    context "learning to drive a car tasklist" do
      let(:config) { described_class.new("learn-to-drive-a-car") }

      it "configures a sidebar" do
        expect(config.tasklist[:heading_level]).to eql(3)
        expect(config.tasklist[:small]).to be true
      end

      it "has symbolized keys" do
        config.tasklist.keys.each do |key|
          expect(key.is_a?(Symbol)).to be true
        end
      end

      it "has a link in the correct structure" do
        first_link = config.tasklist[:groups][0][0][:contents][1][:links][0]
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
          config.primary_paths.sort
        ).to match_array(primary_paths)
      end

      it 'has related paths' do
        related_paths = %w(
          /apply-for-your-full-driving-licence
          /automatic-driving-licence-to-manual
          /complain-about-a-driving-instructor
          /driving-licence-fees
          /driving-test-cost
          /dvlaforms
          /find-theory-test-pass-number
          /government/publications/application-for-refunding-out-of-pocket-expenses
          /government/publications/drivers-record-for-learner-drivers
          /government/publications/driving-instructor-grades-explained
          /government/publications/know-your-traffic-signs
          /government/publications/l-plate-size-rules
          /guidance/rules-for-observing-driving-tests
          /report-an-illegal-driving-instructor
          /report-driving-medical-condition
          /report-driving-test-impersonation
          /seat-belts-law
          /speed-limits
          /track-your-driving-licence-application
          /vehicle-insurance
          /driving-lessons-learning-to-drive/practising-with-family-or-friends
          /driving-lessons-learning-to-drive/taking-driving-lessons
          /driving-lessons-learning-to-drive/using-l-and-p-plates
          /driving-test
          /driving-test/changes-december-2017
          /driving-test/disability-health-condition-or-learning-difficulty
          /driving-test/driving-test-faults-result
          /driving-test/test-cancelled-bad-weather
          /driving-test/using-your-own-car
          /driving-test/what-happens-during-test
          /pass-plus/apply-for-a-pass-plus-certificate
          /pass-plus/booking-pass-plus
          /pass-plus/car-insurance-discounts
          /pass-plus/local-councils-offering-discounts
          /pass-plus/how-pass-plus-training-works
          /theory-test
          /theory-test/hazard-perception-test
          /theory-test/if-you-have-safe-road-user-award
          /theory-test/multiple-choice-questions
          /theory-test/pass-mark-and-result
          /theory-test/reading-difficulty-disability-or-health-condition
        ).sort

        expect(
          config.related_paths.sort
        ).to match_array(related_paths)
      end
    end

    context "get a divorce tasklist" do
      let(:config) { described_class.new("get-a-divorce") }

      it "configures a sidebar" do
        expect(config.tasklist[:heading_level]).to eql(3)
        expect(config.tasklist[:small]).to be true
      end

      it "has symbolized keys" do
        config.tasklist.keys.each do |key|
          expect(key.is_a?(Symbol)).to be true
        end
      end

      it 'has all the primary paths' do
        primary_paths = %w(
          /divorce
          /looking-after-children-divorce
          /money-property-when-relationship-ends
          /benefits-calculators
          /report-benefits-change-circumstances
          /contact-pension-service
          /visas-when-you-separate-or-divorce
          /stay-in-home-during-separation-or-divorce
          /divorce/file-for-divorce
          /divorce/grounds-for-divorce
          /get-help-with-court-fees
          /find-a-legal-adviser
          /divorce-missing-husband-wife
          /divorce/if-your-husband-or-wife-lacks-mental-capacity
          /divorce/apply-for-decree-nisi
          /divorce/apply-for-a-decree-absolute
        ).sort

        # there are two primary paths twice in the JSON structure
        # that's legit.
        expect(
          config.primary_paths.sort.uniq
        ).to match_array(primary_paths)
      end

      it 'has related paths' do
        related_paths = %w(
          /stay-in-home-during-separation-or-divorce
          /copy-decree-absolute-final-order
          /visas-when-you-separate-or-divorce
          /contact-grandchild-parents-divorce-separate
          /government/publications/application-for-a-state-pension-forecast-on-divorce-or-dissolution-br20
          /government/publications/family-law-the-ground-for-divorce
          /government/publications/get-a-copy-of-a-domestic-violence-protection-notice--2
          /how-to-annul-marriage
          /marriage-allowance/if-your-circumstances-change
          /changing-passport-information/divorce-or-returning-to-a-previous-surname
          /make-will/updating-your-will
          /marriage-allowance/if-your-circumstances-change
          /marriage-allowance/how-to-apply
          /make-will
          /make-will/writing-your-will
          /make-will/make-sure-your-will-is-legal
          /divorce/respond-to-a-divorce-petition
        ).sort

        expect(
          config.related_paths.sort
        ).to match_array(related_paths)
      end

      it "has a link in the correct structure" do
        first_link = config.tasklist[:groups][0][0][:contents][1][:links][0]
        expect(first_link[:href]).to eql("https://www.relate.org.uk/relationship-help/help-separation-and-divorce")
        expect(first_link[:text]).to eql("Get advice from Relate")
      end
    end
  end
end
