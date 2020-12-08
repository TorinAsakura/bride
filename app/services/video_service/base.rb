module VideoService
  AVAILABLE_VIDEO_PLATFORMS = %w(vk vimeo)
  class VideoService::Base
    attr_reader :video
    def initialize(current_user, params={})
      @service_obj = case params[:content]
      when /vk/    then VideoService::VkontakteVideoService.new(current_user, params)
      when /vimeo/ then VideoService::VimeoVideoService.new(params)
      end
    end

    def player
      @service_obj.player
    end

    def duration
      @service_obj.duration
    end

    def original_link
      @service_obj.original_link
    end

    def preview_image
      @service_obj.preview_image
    end
  end
end
