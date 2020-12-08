class CommunityPostCategory < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true

  has_many :posts, foreign_key: 'category_id', dependent: :destroy
  belongs_to :community
end
