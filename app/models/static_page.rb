class StaticPage < ActiveRecord::Base
  attr_accessible :title, :content, :is_active, :link

  validates :title, :link, :presence => true

  validates :link, static_page_link_format: {unless: 'link.blank?'}
  validates :link, uniqueness: {unless: 'link.blank?'}

  scope :active, -> { where(is_active: true) }

  before_save :strip_slash

  def is_visible?
    is_active
  end

  private

  def strip_slash
    while self.link =~ /\/{2}/ do
      self.link.gsub! '//', '/'
    end

    self.link.slice!(0) if '/' == self.link[0]
    self.link.slice!(-1) if '/' == self.link[-1]

    self.link = self.link
  end
end
