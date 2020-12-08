# encoding: utf-8
class WeddingInvite < ActiveRecord::Base
  belongs_to :client,                       with_deleted: true
  belongs_to :couple, class_name: 'Client', with_deleted: true
  attr_accessible :couple_id

  validates :couple_id, presence: true
  validates :client_id, presence: true

  validate :couple_has_various_gender

  private
  def couple_has_various_gender
    if !!couple.gender == !!client.gender
       errors.add :gender, 'Ошибка полов'
    end
  end
end
