class Bonus::CityDealerPercent < ActiveRecord::Base
  belongs_to :service
  belongs_to :city
  attr_accessible :percent

  validates :percent, presence:true
  validates :percent, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
end
