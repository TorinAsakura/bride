module VideoService
  class VideoService::VkontakteVideoService < VideoService::Base
    def initialize(user, video_params)
      @params = video_params
      @video_link = video_params[:content]
      initialize_vkontakte_api_client(user)
    end

    def player
      player = @vk_client.video.get(videos: video_link_id).second.player
      if player.match(/youtube/)
        youtube_video_id = player.match(/(?<=)([a-zA-Z0-9_-]){11}/i).to_s
        return "http://www.youtube.com/watch?v=#{youtube_video_id}"
      elsif player.match(/vimeo/)
        vimeo_video_link = player[5..-1]
        return "#{vimeo_video_link}?color=ffffff"
      else
        return player
      end
    end

    def preview_image
      @vk_client.video.get(videos: video_link_id).second.image
    end

    def duration
      duration_in_seconds = @vk_client.video.get(videos: video_link_id).second.duration
      Duration.new(duration_in_seconds).format("%H:%M:%S")
    end

    def original_link
      "http://vk.com/video#{video_link_id}"
    end


    private
    def video_link_id
      parse_link
    end

    def initialize_vkontakte_api_client(user)
      token = user.authorizations.where(provider: "vkontakte").first.token
      @vk_client = VkontakteApi::Client.new token
    end

    def parse_link
      #можете проклинать меня
      if @video_link.include? "video_ext"
        oid = @video_link.match(/oid\=.[0-9]+/i).to_s.match(/[0-9]+/).to_s
        id = @video_link.match(/[^o]id\=[0-9]+/i).to_s.match(/[0-9]+/).to_s
        if @video_link.include? '-'
          "-#{oid}_#{id}"
        else
          "#{oid}_#{id}"
        end
      else
        if @video_link.include? '-'
          @video_link.match(/.[0-9]+._[0-9]+/).to_s
        else
          @video_link.match(/[0-9]+._[0-9]+/).to_s
        end
      end
    end
  end
end
