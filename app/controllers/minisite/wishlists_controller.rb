# encoding: utf-8
class Minisite::WishlistsController < Minisite::MinisitesController
  skip_before_filter :authenticate_user!
  before_filter :access_checks_on_minisite

  def index
    @white_list = WishlistDecorator.decorate_collection(@site.wishlists.includes(:image).white_list.created_asc)
    @black_list = WishlistDecorator.decorate_collection(@site.wishlists.black_list.created_asc)
    @pages = @site.try :pages
  end
end
