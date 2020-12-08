# encoding: utf-8
class Guest < ActiveRecord::Base
  attr_accessible :drink, :email, :gender, :name, :group, :dowry, :ceremony, :banquet, :user, :site_id
  GROUPS = %w(groom bride)
  STATUSES = %w(dowry ceremony banquet)
  acts_as_list scope: [:site_id, :group]

  belongs_to :user
  belongs_to :site

  scope :groom,   -> { where(group: 'groom').ordered }
  scope :bride,   -> { where(group: 'bride').ordered }
  scope :ordered, -> { order('position asc') }

  validates :name, :group, :site, presence: true
  validates :gender, inclusion: {in: [true, false]}
  validates :group, inclusion: {in: GROUPS}

  after_create :invite_guest

  def confirm!(status)
    self.update_attribute(status, !self.send(status))
  end

  private
  def invite_guest
    if email.present?
      if (user = User. find_by_email(email)).blank?
        names = self.name.strip.split(' ').map(&:strip).compact
        first_name = names.count.eql?(3) ? names[1] : names[0]
        last_name = names.count.eql?(3) ? names[0] : names[1]
        resource = Client.new(firstname: first_name, lastname: last_name, gender: self.gender)
        resource.save
        user = User.invite!({ email: email,
                              login: email,
                              profileable_type: 'Client',
                              profileable_id: resource.id,
                              read: true }, self.site.user).save
      end
      self.user = user
      self.save
    end
  end
end
