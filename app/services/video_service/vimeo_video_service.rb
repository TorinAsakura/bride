module VideoService
  class VideoService::VimeoVideoService < VideoService::Base
    def initialize(video_params)
      @params = video_params
      @video_link = video_params[:content]
      @video_id = parse_link
    end

    def player
      "//player.vimeo.com/video/#{@video_id}?color=ffffff"
    end

    def original_link
      "http://vimeo.com/#{@video_id}"
    end

    def preview_image
      v = Vimeo::Simple::Video.info(@video_id.to_s)
      v.parsed_response.first["thumbnail_large"]
    end

    def duration
      v = Vimeo::Simple::Video.info(@video_id.to_s)
      duration_in_seconds = v.parsed_response.first["duration"]
      Duration.new(duration_in_seconds).format("%H:%M:%S")
    end

    private
    def parse_link
      if @video_link.include? "player"
        @video_link.match(/[0-9]+/).to_s
      else
        @video_link.match(/[0-9]+$/).to_s
      end
    end
  end
end
