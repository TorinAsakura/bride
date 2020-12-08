# encoding: utf-8
module CommunitiesHelper

  def community_post_date date_time
    if date_time.to_date == Date.today
      "сегодня в #{date_time.strftime('%H:%M')}"
    else
      l(date_time)
    end
  end

  def path_to_community_image community, image
    if params[:post_id].present?
      community_post_image_path(community, image.imageable, image)
    else
      community_image_path(community, image)
    end
  end
end
