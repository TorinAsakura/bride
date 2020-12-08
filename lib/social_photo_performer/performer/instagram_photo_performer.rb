module SocialPhotoPerformer
  module Performer
    class InstagramPhotoPerformer < SocialPhotoPerformer::Base
      attr_reader :tmp_poll_images_ids

      def initialize(client, params)
        @album = Album.find(params[:album_id]) if params[:album_id].present?
        @pictures_paths = []
        @tmp_poll_images_ids = []
        @client = client
        @instagram_photo_ids = params[:instagram_photo_ids]
      end

      def create_tmp_images_from_remote_data
        images_urls = []
        @instagram_photo_ids.each do |photo_id|
          remote_image_data = @client.media_item(photo_id)
          images_urls << remote_image_data.images.standard_resolution.url
        end

        images_urls.each do |url|
          image_ext = IMAGE_EXT.match(url).to_s
          @pictures_paths << save_tmp_image(image_ext, url)
        end
      end
    end
  end
end
