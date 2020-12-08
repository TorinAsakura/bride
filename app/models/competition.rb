# encoding: utf-8
class Competition < ActiveRecord::Base
  mount_uploader :banner, CompetitionBannerUploader

  attr_accessible :firm_id, :name, :about_competition, :rules, :about_prizes, :start_date, :deadline_date, :is_started, :banner
  attr_accessible :firm_id, :name, :about_competition, :rules, :start_date, :deadline_date, :banner, :competition_prizes_attributes

  has_many :competition_prizes
  accepts_nested_attributes_for :competition_prizes, allow_destroy: true

  belongs_to :firm
  delegate :name, :to => :firm, :prefix => true

  has_many :albums, :as => :resource
  has_many :photos, :through => :albums

  validates :name, :about_competition, :rules, :about_prizes, :start_date, :deadline_date, :presence => true

  def winners
    albums = self.albums
    albums_hash = {}
    albums.each do |album|
      albums_hash[album.id] = album.likes.count
    end
    albums_hash
  end
  has_many :votes, :as => :albums

  validates :name, :about_competition, :rules, :start_date, :deadline_date, :presence => true

  def self.active_competitions
    competitions = self.where("start_date <= ?", Date.today)
    competitions = competitions.order("deadline_date DESC")
  end

  def winners_defined?
    # Выбираем альбомы для конкурса отсортированные по убыванию количества лайков
    albums = Album.where(resource_type: self.class)
    albums = albums.where(resource_id: self.id)
    albums = albums.order("cached_votes_up DESC")

    # определяем количество призовых мест
    limit = self.competition_prizes.count

    # отбираем первые три призовых места
    albums_top = albums.limit(limit).pluck(:cached_votes_up)
    albums_count = albums_top.count
    # считаем уникальные показатели
    albums_uniq_likes_count = albums_top.uniq.count

    # условие определения поебедителей призовые места имеют разное количество лайков
    albums_count == albums_uniq_likes_count
  end
end
