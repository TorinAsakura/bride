# encoding: utf-8
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :regions, :cities, :register, :search]
  before_filter :update_visited_at, only: :index

  def index
    @banners = [Banner.system, Banner.ads].flatten

    @ideas = Idea::Collection.homepage_ideas

    @posts = Post.accepted
                 .reorder('id DESC')
                 .page(params[:page])
                 .per(HOMEPAGE_POSTS)

    @videos = MediaContent.videos
                          .accepted
                          .reorder('id DESC')
                          .page(params[:page])
                          .per(HOMEPAGE_VIDEOS)

    @clients = Client.where('avatar IS NOT NULL AND avatar != \'\'')
                     .reorder('visited_at DESC')
                     .limit(HOMEPAGE_CLIENTS)

    @sites = Site.joins(client: [:wedding])
                 .where('logo IS NOT NULL AND name IS NOT NULL AND wedding_date IS NOT NULL')
                 .reorder('RANDOM()')
                 .limit(HOMEPAGE_SITES)

    @client = current_client ? current_client.decorate : current_client
    @wedding = Wedding.new
    @site = Site.new
    @pro = Bonus::Service::Pro.find_by_slug('pro')

    case params[:resource]
      when 'posts' then render 'home/posts'
      when 'videos' then render 'home/videos'
      else render 'home/index'
    end
  end

  def search
    case params['search-where']
    when 'idea'
      redirect_to idea_ideas_path(idea: {tag_list: params[:search].presence, color_ids: params[:idea][:color_ids].presence}) and return
    when 'article'
      redirect_to interesting_path(tags: params[:search].presence) and return
    when 'people'
      redirect_to clients_path(search: {fullname: params[:search].presence}) and return
    when 'company'
      redirect_to firms_path(firms_search: params[:search].presence) and return
    else
      redirect_back
    end
  end

  def wedding_start
    #страница о успешном начале подготовки к свадьбе
  end

  def regions
    @list = Region.where(:country_id => params[:id])

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def cities
    @list = City.where(:region_id => params[:id])

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def city_search
    @cities = City.search_like_name(params[:q])
    render json: @cities.collect { |r| {id: r.id, text: r.text} }
  end

  def tags
    tags = Tag.like(params[:q])
    render :json => tags.collect{|t| {:id => t.name, :name => t.name }}
  end

  private
  def update_visited_at
    current_client.update_attribute(:visited_at, DateTime.now) if current_client.present?
  end
end
