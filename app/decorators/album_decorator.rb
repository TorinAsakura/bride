class AlbumDecorator < Draper::Decorator
  delegate_all

  def cover_url
    object.cover.try(:path).try(:cover) || h.asset_path('placeholders/album.png')
  end
end
