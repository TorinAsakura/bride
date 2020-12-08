# encoding: utf-8
class Album < ActiveRecord::Base
  self.table_name = 'photo_albums'

  belongs_to :resource, polymorphic: true
  has_one :firm, foreign_key: 'banner_album_id'
  has_many :photos, dependent: :delete_all, foreign_key: 'photo_album_id', order: 'id DESC'
  belongs_to :cover, class_name: 'Photo', foreign_key: :cover_id
  accepts_nested_attributes_for :photos, allow_destroy: true

  attr_accessor :pictures, :new_photos
  attr_accessible :name, :cover, :count, :photos_attributes, :cover_id, :description, :pictures, :new_photos, :system

  acts_as_votable

  scope :ordered, ->{order('id desc')}


  after_save :save_pictures

  paginates_per 10

  def cover
    super || self.photos.first
  end

  def root_object
    resource.try(:root_object)
  end

  def update_for_banner_album params
    if params
      self.update_attributes(params)
      self.cover = self.photos.last
      self.save
    end
  end

  def is_resource? *args
    if self.resource.class.name == 'User'
      args.include? self.resource.profileable.class.name
    else
      args.include? self.resource.class.name
    end
  end

  private
  def save_pictures
    unless self.pictures.blank?
      banner_album = (system==1)
      self.new_photos = []
      self.pictures.each do |pic|
        if banner_album
          if pic.has_key? :id
            photo = self.photos.find(pic[:id])
            photo.update_attributes(pic)
            photo.banner_path.cache_stored_file!
            photo.banner_path.retrieve_from_cache!(photo.banner_path.cache_name)
            photo.banner_path.recreate_versions! :usual
            photo.save!
          else
            self.photos.create(pic)
          end
        else
          self.photos.create(pic)
        end
      end
    end
  end

end
