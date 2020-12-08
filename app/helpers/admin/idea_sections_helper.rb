# encoding: utf-8
module Admin::IdeaSectionsHelper

  def short_ver text, num
    text && text.length > num ? text[0, num] + "..." : text
  end

end