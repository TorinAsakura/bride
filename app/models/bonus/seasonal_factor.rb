class Bonus::SeasonalFactor < ActiveRecord::Base
  belongs_to :service
  attr_accessible :discount, :month

  validates :month, :discount, presence: true
  validates :discount, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  validates :month, numericality: true, inclusion: (1..12).to_a

  default_scope order(:month)

  def coefficient
    (100-discount.to_f)/100
  end
end
