# encoding: utf-8
class Wishlist < ActiveRecord::Base
  scope :created_asc, -> { order('wishlists.created_at ASC') }
  scope :white_list, -> { where('wishlists.wish =?', true) }
  scope :black_list, -> { where('wishlists.wish =?', false) }

  belongs_to :site
  belongs_to :client
  has_one :image, class_name: 'WishlistImage', as: :imageable, dependent: :destroy

  has_many :promises

  attr_accessible :description, :name, :url, :wish, :image_attributes
  accepts_nested_attributes_for :image

  validates :name, :site, :client, presence: true

end
