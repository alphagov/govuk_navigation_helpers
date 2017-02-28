module GovukNavigationHelpers
  module Guidance
    # DO NOT COPY THIS LIST
    # This hard-coded list is a temporary measure, and will eventually be replaced by a change in Rummager that
    # will allow us to search for "Guidance" content.
    # See: https://trello.com/c/hxGPJ9jw/435-consolidate-guidance-document-types-into-search
    DOCUMENT_TYPES = %w[
      answer
      contact
      detailed_guide
      document_collection
      form
      guidance
      guide
      licence
      local_transaction
      manual
      map
      notice
      place
      programme
      promotional
      regulation
      simple_smart_answer
      smart_answer
      statutory_guidance
      transaction
      travel_advice
      ].freeze
  end
end
