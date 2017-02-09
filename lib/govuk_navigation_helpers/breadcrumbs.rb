require 'govuk_navigation_helpers/content_item'
require 'govuk_navigation_helpers/publishing_api_linked_edition'

module GovukNavigationHelpers
  class Breadcrumbs
    def initialize(content_item)
      @content_item = content_item
    end

    def self.from_expanded_links_response(**options)
      new(PublishingApiLinkedEdition(options))
    end

    def self.from_content_store_response(content_store_response)
      new(ContentItem.new(content_store_response))
    end

    def breadcrumbs
      all_parents.reverse
    end

  private

    attr_reader :content_item

    def all_parents
      parents = []

      direct_parent = content_item.parent
      while direct_parent
        parents << direct_parent

        direct_parent = direct_parent.parent
      end

      parents
    end
  end
end
