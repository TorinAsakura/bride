module VkontaktePaginator
  PHOTO_LIMIT_PER_CALL = 20
  def self.paginate(params, vk_client)
    if params[:next]
      vk_client.photos.get(album_id: params[:id].to_i, limit: PHOTO_LIMIT_PER_CALL, offset: params[:offset])
    elsif(params[:previos])
      vk_client.photos.get(album_id: params[:id].to_i, limit: PHOTO_LIMIT_PER_CALL, offset: 0)
    else
      vk_client.photos.get(album_id: params[:id].to_i, limit: PHOTO_LIMIT_PER_CALL)
    end
  end
end
