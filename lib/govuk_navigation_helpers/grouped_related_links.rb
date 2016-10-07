module GovukNavigationHelpers
  # Take a content item and group the related links according to an algorithm
  # that is intended to display the related links into three groups, depending
  # on how much they have in common with the main content item.
  #
  # @private
  class GroupedRelatedLinks
    attr_reader :content_item

    def initialize(content_item)
      @content_item = content_item
    end

    # This will return related items that have the same `parent` (breadcrumb)
    # as the content item.
    def related_with_parent_in_common
      return [] unless content_item.parent

      @related_with_parent_in_common ||= content_item.related_links.select do |related_item|
        next unless related_item.parent
        related_item.parent.content_id == content_item.parent.content_id
      end
    end

    # This will contain related items that have a grandparent in common with
    # the content item.
    def related_with_grandparent_in_common
      return [] unless content_item.parent && content_item.parent.parent

      @related_with_grandparent_in_common ||= content_item.related_links.select do |related_item|
        next unless related_item.parent && related_item.parent.parent
        related_item.parent.parent.content_id == content_item.parent.parent.content_id
      end
    end

    # This will contain the related items that have a completely different
    # parent/breadcrumb from the content item.
    def related_with_no_parents_in_common
      all_content_ids = (related_with_parent_in_common + related_with_grandparent_in_common).map(&:content_id)

      @related_with_no_parents_in_common ||= content_item.related_links.reject do |related_item|
        all_content_ids.include?(related_item.content_id)
      end
    end
  end
end
