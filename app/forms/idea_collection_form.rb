class IdeaCollectionForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers

  attr_reader :collection, :redirect_url

  delegate :ideas, to: :collection

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Idea::Collection')
  end

  def initialize(collection)
    @collection = collection
    @new_ideas = []
  end

  def submit(params)
    @collection.assign_attributes(params.slice(:name, :ideas_attributes))

    if valid?
      @collection.save!
      create_ideas(params[:pictures])
      build_redirect_url(params)
      true
    else
      false
    end
  end

  private
  def build_redirect_url(params)
    if params.has_key? :pictures
      @redirect_url = edit_admin_idea_collection_path(@collection.id, list: @new_ideas)
    else
      @redirect_url = admin_idea_collection_path(@collection)
    end
  end

  def create_ideas(pictures)
    unless pictures.blank?
      pictures.each do |pic|
        @new_ideas << @collection.ideas.create(image_attributes: { image: pic })
      end
    end
  end
end
