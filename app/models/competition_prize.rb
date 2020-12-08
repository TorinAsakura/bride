# encoding: utf-8
class CompetitionPrize < ActiveRecord::Base
  mount_uploader :picture, PrizePictureUploader

  attr_accessible :title, :description, :picture, :competition_id
  belongs_to :competition

  delegate :id, to: :competition, prefix: true

  validates :title, :description, presence: true

end
