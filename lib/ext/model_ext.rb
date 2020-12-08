module ModelExt
  module Paginates
    def get_paginate event, page, count  
      tag_list = event.task.present? ? event.task.tag_list : event.tag_list
      tagged_with(tag_list, any: true).page(page).per(count)
    end
  end
end
