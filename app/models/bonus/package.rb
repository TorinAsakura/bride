class Bonus::Package < ActiveRecord::Base
  belongs_to :service
  attr_accessible :percent, :months_count

  validates :percent, :months_count, presence: true
  validates :months_count, numericality: true
  validates :percent, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 150}

  default_scope order('months_count desc')

  def coefficient
    (100+percent.to_f)/100
  end

  def amount_coefficient
    months_count*coefficient/12
  end
end
