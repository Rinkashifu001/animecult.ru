module LinkPaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer

    @object_type_accessed = nil

    def prepare(collection, options, template)
      @object_type_accessed = options[:controller_accessed]
      super
    end

    def link(text, target, attributes = {})
      if text == 1
        return "<a rel=\"prev start\" href=\"/#{@object_type_accessed}\">1</a>"
      end
      super
    end

    def previous_or_next_page(page, text, classname)
      if page == 1
        return "<a class=\"previous_page\" rel=\"prev\" href=\"/#{@object_type_accessed}\">#{I18n.t('will_paginate.previous_label')}</a>"
      end
      super
    end
  end
end 