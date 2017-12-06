module GovukNavigationHelpers
  module TasklistPages
    PRIMARY_PAGES = %w(
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
    ).freeze

    SECONDARY_PAGES = %w(
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
    ).freeze

    MATCHING_PAGES = %w(
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
    ).freeze
  end
end
