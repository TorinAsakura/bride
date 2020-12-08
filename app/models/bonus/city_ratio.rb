class Bonus::CityRatio < ActiveRecord::Base
  belongs_to :service
  belongs_to :city
  attr_accessible :percent # +/- percents

  validates :percent, presence:true, numericality: {greater_than_or_equal_to: -50, less_than_or_equal_to: 50}

  def coefficient
    (100+percent.to_f)/100
  end
end
