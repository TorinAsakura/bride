class PostForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates :user, :journal, presence: true
  validates :category_id, presence: true, if: lambda{ post.is_resource? 'Community' }
  validates :title, :body, :illustration, presence: true, on: :update

  delegate :title, :body, :illustration, :journal, :user, :status, :tags, :tag_list, :images, :videos, :new_record?, :category_id, to: :post

  attr_reader :post

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Post')
  end

  def initialize(post, user)
    @post = post
    @post.user = user
  end

  def submit(params)
    @post.assign_attributes(params.slice(:body, :title, :tag_list, :category_id))
    @post.status = params[:status].present? ? 1 : 0 # 0 for not recommended, 1 for recommended

    if valid?
      build_illustration(params[:illustration])
      @post.save!
      create_illustration(params[:illustration])
      create_videos(params[:videos])
      true
    else
      false
    end
  end

  def method
    new_record? ? :post : :put
  end

  private
  def create_videos(videos)
    videos.try(:each) do |video|
      @post.videos.create(content: video[:content], video: true)
    end
  end

  def build_illustration(illustration)
    if illustration.present? && illustration[:image].present?
      @post.build_illustration unless @post.illustration.present?
    end
  end

  def create_illustration(illustration)
    if illustration.present? && illustration[:image].present?
      @post.illustration.update_attributes(illustration)
    end
  end
end
