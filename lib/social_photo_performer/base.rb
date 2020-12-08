module SocialPhotoPerformer
  class SocialPhotoPerformer::Base
    attr_reader :album, :images, :pictures_paths, :performer
    IMAGE_EXT = /\.+[a-z]{3,6}$/i

    def initialize(type, client, params)
      performer_name = "SocialPhotoPerformer::Performer::#{type.capitalize}PhotoPerformer".constantize
      @performer = performer_name.new(client, params)
      @upload_to_poll = upload_to_poll?(params)
    end

    def perform!
      @performer.create_tmp_images_from_remote_data
      if @upload_to_poll
        @performer.create_tmp_poll_images_from_tmp_storage
      else
        @performer.create_photos_from_tmp_storage
      end
      @performer.delete_tmp_images
    end

    protected
    def save_tmp_image(image_ext, url)
      file_path = "tmp/_photo_#{rand(1000000)}#{image_ext}"

      File.open(file_path, "wb") do |f|
        f.write HTTParty.get(url).parsed_response
      end

      file_path
    end

    def upload_to_poll?(params)
      params[:upload_to] == 'poll'
    end

    def create_tmp_poll_images_from_tmp_storage
      self.pictures_paths.each do |pic|
        tmp_poll_image = PollTmpImage.new
        tmp_poll_image.image = File.open(pic)
        tmp_poll_image.save!
        @tmp_poll_images_ids << tmp_poll_image.id
      end
    end

    def create_photos_from_tmp_storage
      self.pictures_paths.each do |pic|
        p = Photo.new
        p.usual_path = File.open(pic)
        p.photo_album_id = self.album.id
        p.save
      end
    end

    def delete_tmp_images
      self.pictures_paths.each do |path|
        File.delete(path)
      end
    end
  end
end
