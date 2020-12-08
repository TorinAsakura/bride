# encoding: utf-8
class Minisite::BaseController < ApplicationController
  layout 'clients_site'
  include Subdomain

  before_filter :find_site
  before_filter :access_checks_on_minisite
  before_filter :has_menu

  protected
  def has_menu
    @with_menu = true
  end

  def access_to_moderate_site
    authorize! :moderate, @site
  end
end