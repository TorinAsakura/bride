# encoding: utf-8
class CompetitionsController < ApplicationController
  respond_to :js, :html

  # only owners:
  before_filter :check_owner, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @competitions = Competition.active_competitions
  end

  def firm_index
    @competitions = Competition.where(:firm_id =>params[:firm_id])
    @firm = Firm.find(params[:firm_id])
  end

  def new
    @competition = Competition.new
    # @albums = @competition.albums
  end

  def create
    if @competition = Competition.create(params[:competition])
      redirect_to firm_competition_albums_path(@firm, @competition)
    else
      render :new
    end
  end

  def show
    @firm = Firm.find(params[:firm_id])
    @competition = Competition.find(params[:id])
    @albums = @competition.albums
  end

  def detail
    @competition = Competition.find(params[:id])
    @firm = @competition.firm
    @albums = @competition.albums
    @winners = @competition.winners

    @albums = Album.where(resource_type: 'Competition').where(resource_id: @competition.id).order("cached_votes_up DESC")

    @winners_defined = @competition.winners_defined?
  end

  def edit
    @firm = Firm.find(params[:firm_id])
    @competition = Competition.find(params[:id])
    @albums = @competition.albums
  end

  def update
    @competition = Competition.find(params[:id])

    if @competition.update_attributes(params[:competition])
      if params[:remove_banner] == '1'
        @competition.remove_banner!
        @competition.save
      end
      redirect_to firm_competition_albums_path(@firm, @competition)
    else
      render :edit
    end
  end

  def destroy
    @competition = Competition.find(params[:id])

    @competition.destroy

    redirect_to firm_index_fitm_competitions_url
  end

  def like_album
    @album = Album.find(params[:album_id])
    @album.liked_by current_user

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def unlike_album
    @album = Album.find(params[:album_id])
    @album.disliked_by current_user

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def check_owner
    @firm = Firm.find(params[:firm_id])
    redirect_to :action => "index" unless (@firm.user == current_user || current_user.has_role?(:admin))
  end
end
