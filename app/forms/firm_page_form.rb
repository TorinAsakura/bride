class FirmPageForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :firm_page

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'FirmPage')
  end

  def initialize(firm_page, firm)
    @firm_page = firm_page
    @firm = firm
  end

  def submit(params = {})
    @firm_page.assign_attributes(params.slice(:title, :body))
    @video_params = params[:videos]

    if valid?
      set_rating if @firm_page.new_record?
      hide_empty
      @firm_page.save!
      create_videos(@video_params)
      true
    else
      false
    end
  end

  private
  def set_rating
    @firm_page.rating = @firm.firm_pages.empty? ? 1 : @firm.firm_pages.maximum(:rating) + 1 if @firm
  end

  def hide_empty
    @firm_page.shown = false if @firm_page.title.blank? && @firm_page.body.blank?
  end

  def create_videos(videos)
    videos.try(:each) do |video|
      @firm_page.videos.create(content: video[:content], video: true)
    end
  end

  def no_videos?
    @video_params.blank? || @video_params.try(:all?) { |attrs| attrs[:content].blank? }
  end
end
