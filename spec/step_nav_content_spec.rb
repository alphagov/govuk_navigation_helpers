require 'spec_helper'

module GovukNavigationHelpers
  RSpec.describe StepNavContent do
    let(:path) { '/pass-plus' }
    let(:step_nav_content) { described_class.new(file_name: "learn-to-drive-a-car", path: path) }

    context '.current_step_nav' do
      context 'based on the request' do
        context 'when the path is /pass-plus' do
          it 'returns "Learn to Drive" step nav' do
            current_step_nav = described_class.current_step_nav(path)

            expect(
              current_step_nav.title
            ).to eql('Learn to drive a car: step by step')
          end
        end
      end
    end

    context '#show_step_nav?' do
      context 'when the requested path is part of the current step nav' do
        it 'returns true' do
          expect(
            step_nav_content.show_step_nav?
          ).to be true
        end
      end

      context 'when the requested path is not part of the current step nav' do
        let(:path) { '/pink-plus' }

        it 'returns false' do
          expect(
            step_nav_content.show_step_nav?
          ).to be false
        end
      end
    end

    context '#set_current_step' do
      it 'sets /pass-plus as active' do
        step_nav_content.set_current_step

        expect(
          step_nav_content.steps.last[:contents].last[:contents][0][:href]
        ).to eql('/pass-plus')

        expect(
          step_nav_content.step_nav[:show_step]
        ).to eql(7)

        expect(
          step_nav_content.steps.last[:contents].last[:contents][0][:active]
        ).to be true
      end
    end

    context "learning to drive a car step nav content" do
      it "has symbolized keys" do
        step_nav_content.step_nav.each_key do |key|
          expect(key.is_a?(Symbol)).to be true
        end
      end

      it "has a title" do
        expect(step_nav_content.title).to eql("Learn to drive a car: step by step")
      end

      it "has a base_path" do
        expect(step_nav_content.base_path).to eql("/learn-to-drive-a-car")
      end

      it "configures a sidebar" do
        expect(step_nav_content.step_nav[:heading_level]).to eql(3)
        expect(step_nav_content.step_nav[:small]).to be true
      end

      it "has a link in the correct structure" do
        first_link = step_nav_content.step_nav[:steps][0][:contents][1][:contents][0]
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
          step_nav_content.primary_paths.sort
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
          /report-driving-test-impersonation
          /track-your-driving-licence-application
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
          step_nav_content.related_paths.sort
        ).to match_array(related_paths)
      end
    end
  end
end
