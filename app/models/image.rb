# encoding: utf-8
class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  attr_accessible :image

  def next_image all_images = false
    if all_images.present? && imageable.journal.images.count > 1
      imageable.journal.images.where('images.id < ?', id).first || imageable.journal.images.first
    elsif imageable.images.count > 1
      imageable.images.where('id < ?', id).last || imageable.images.last
    else
      nil
    end
  end

  def prev_image all_images = false
    if all_images.present? && imageable.journal.images.count > 1
      imageable.journal.images.where('images.id > ?', id).last || imageable.journal.images.last
    elsif imageable.images.count > 1
      imageable.images.where('id > ?', id).first || imageable.images.first
    else
      nil
    end
  end
end
