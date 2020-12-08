# encoding: utf-8
class Sphere < ActiveRecord::Base
  acts_as_paranoid

  belongs_to  :firm
  belongs_to  :firm_catalog
  has_many    :specifications

  accepts_nested_attributes_for :firm_catalog, :specifications
  attr_accessible :base, :firm_catalog_id, :specifications_attributes

  validates :firm_catalog, :firm, presence: true
  validates :firm_catalog_id, uniqueness: {scope: :firm_id}

  scope :base,            -> { where(base: true) }
  scope :by_firm_catalog, ->(firm_catalog) { where(spheres: { firm_catalog_id: firm_catalog.try(:id)})}

  after_create :add_base

  def not_payed?
    !payed?
  end

  def payed?
    self.firm.bonus_subscriptions.signing_object(self.firm_catalog).first.present?
  end

  private
  def add_base
    self.update_attribute(:base, firm.spheres.count.eql?(1))
  end

  def paranoid_recover!
    self.recover
    self.send(:add_base)
  end
end
