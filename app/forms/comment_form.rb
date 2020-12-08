class CommentForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates_presence_of :user
  validate :validate_level
  validate :validate_content_presence

  delegate :body, :user, to: :comment

  attr_reader :comment

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Comment')
  end

  def initialize(comment)
    @comment = comment
  end

  def submit(params)
    @comment.body = params[:body]
    @video_params = params[:videos]
    @images_count = params[:images_count].to_i

    if valid?
      @comment.save!
      create_videos(@video_params)
      true
    else
      false
    end
  end

  private
  def validate_level
    if @comment.parent_id && Comment.find(@comment.parent_id).level + 1 >= @comment.commentable_type.constantize::DEPTH
      errors.add :comment, 'has too deep nesting level'
    end
  end

  def validate_content_presence
    if @comment.body.blank? && @images_count.zero? && no_videos?
      errors.add :comment, 'is empty'
    end
  end

  def create_videos(videos)
    videos.try(:each) do |video|
      @comment.videos.create(content: video[:content], video: true)
    end
  end

  def no_videos?
    @video_params.blank? || @video_params.try(:all?) { |attrs| attrs[:content].blank? }
  end
end
