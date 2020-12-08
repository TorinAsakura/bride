class Bonus::Loyalty < ActiveRecord::Base
  belongs_to :service
  attr_accessible :discount, :years_count

  validates :discount, :years_count, presence: true
  validates :years_count, numericality: true
  validates :discount, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 10}

  scope :ordered, -> {order(:years_count)}

  def coefficient
    (100-discount.to_f)/100
  end
end
