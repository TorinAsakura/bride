module InstagramPaginator
  def self.paginate(params, instagram_client)
    if params[:next]
      instagram_client.user_recent_media(max_id: params[:max_id])
    elsif(params[:previos])
      instagram_client.user_recent_media(min_id: params[:last_image])
    else
      instagram_client.user_recent_media
    end
  end
end
