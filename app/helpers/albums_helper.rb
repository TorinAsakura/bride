# encoding: utf-8
module AlbumsHelper

  def album_form_url resource, album
    if resource.class.name == 'Community' || resource.user.client?
      album.new_record? ? polymorphic_path([resource, :albums]) : polymorphic_path([resource, @album])
    else
      album.new_record? ? albums_path : album_path(album)
    end
  end

  def albums_form_url resource
    resource.class.name != 'Community' && resource.user.firm? ? albums_path : polymorphic_path([resource, :albums])
  end
end
