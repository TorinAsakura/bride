class MessageForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :message

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Message')
  end

  def initialize(message)
    @message = message
  end

  def submit(params = {})
    @message.assign_attributes(params.slice(:subject, :body))
    @video_params = params[:videos]

    if valid?
      @message.save!
      create_videos(@video_params)
      true
    else
      false
    end
  end

  private
  def create_videos(videos)
    videos.try(:each) do |video|
      @message.videos.create(content: video[:content], video: true)
    end
  end

  def no_videos?
    @message.blank? || @video_params.try(:all?) { |attrs| attrs[:content].blank? }
  end
end
