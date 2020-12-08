#encoding: utf-8
class FirmService < ActiveRecord::Base
  belongs_to :firm
  attr_accessible :cost, :name, :unit, :raiting


  validates :raiting, numericality: { only_integer: true }
  validates :name, length: { maximum: 50 }

  validates :name, :cost, :unit, presence: { if: :visible? }



  before_create :set_raiting
  after_destroy :reorganize_raitings

  scope :visible, order(:raiting).where('raiting >= 0')

  def visible?
    self.raiting >= 0
  end

  def line
    "#{name}: от #{cost} #{unit}"
  end

  private
  def set_raiting
    self.raiting = (services = firm.firm_services.visible).empty? ? 1 : services.maximum(:raiting) + 1 if visible?
  end

  def reorganize_raitings
    firm.firm_services.visible.sort_by(&:raiting).each_with_index do |s, i|
      s.update_attributes(raiting: i + 1)
    end
  end
end