module SocialPhotoPerformer
  module Performer
    class VkontaktePhotoPerformer < SocialPhotoPerformer::Base
      attr_reader :tmp_poll_images_ids

      def initialize(client, params)
        @album = Album.find(params[:album_id]) if params[:album_id].present?
        @images = client.photos.get(params[:vk_photos_params])
        @pictures_paths = []
        @tmp_poll_images_ids = []
        @client = client
      end

      def create_tmp_images_from_remote_data
        @images.each do |image|
          image_ext = IMAGE_EXT.match(image.src_big).to_s
          original_url = image.src_big
          @pictures_paths << save_tmp_image(image_ext, original_url)
        end
      end
    end
  end
end
