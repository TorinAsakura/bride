# encoding: utf-8
class FirmPage < ActiveRecord::Base
  belongs_to :firm, with_deleted: true

  has_many :images, class_name: 'FirmPageImage', as: :imageable, dependent: :destroy, order: 'id desc'
  has_many :videos, class_name: 'MediaContent', as: :multimedia, conditions: ['media_contents.video = ?', true], order: 'id asc'

  attr_accessible :name, :rating, :shown, :title, :body, :firm_id

  default_scope order(:rating)
  scope :visible, -> { where(shown: true) }
  scope :ordered, -> { order(:rating) }

  def anchor
    name ? "#{name}" : "page#{id}"
  end
end
