module GovukNavigationHelpers
  # Take a content item and group the related links according to an algorithm
  # that is intended to display the related links into three groups, depending
  # on how much they have in common with the main content item.
  #
  # @private
  class GroupedRelatedLinks
    attr_reader :content_item,

      # This will contain related items that have the same `parent` (breadcrumb)
      # as the content item.
      :related_with_parent_in_common,

      # This will contain related items that have a grandparent in common with
      # the content item.
      :related_with_grandparent_in_common,

      # This will contain the related items that have a completely different
      # parent/breadcrumb from the content item.
      :related_with_nothing_in_common

    def initialize(content_item)
      @content_item = content_item
      @related_with_parent_in_common = []
      @related_with_grandparent_in_common = []
      @related_with_nothing_in_common = []
      group_related_links!
    end

  private

    def group_related_links!
      content_item.related_links.each do |related_item|
        if content_item.parent && related_item.parent
          if related_item.parent.content_id == content_item.parent.content_id
            @related_with_parent_in_common << related_item
          elsif related_item.parent.parent.content_id == content_item.parent.parent.content_id
            @related_with_grandparent_in_common << related_item
          else
            @related_with_nothing_in_common << related_item
          end
        else
          @related_with_nothing_in_common << related_item
        end
      end
    end
  end
end
