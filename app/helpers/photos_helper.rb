# encoding: utf-8
module PhotosHelper
  def link_to_album album
    if album.is_resource? 'Site'
      link_to album.name, minisite_album_path(album)
    elsif album.is_resource? 'Firm'
      link_to album.name, album_path(album)
    elsif album.is_resource? 'Community'
      link_to album.name, polymorphic_path([album.resource, album])
    elsif album.is_resource? 'Client'
      link_to album.name, polymorphic_path([album.resource.profileable, album])
    end
  end

  def url_to_photo resource, photo
    resource.class.name != 'Community' && resource.user.firm? ? album_photo_path(photo.album, photo) : polymorphic_path([resource, photo.album, photo])
  end
end
