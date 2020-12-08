# encoding: utf-8
class AdminController < ApplicationController
  before_filter :redirect_if_not_admin

  private
  def redirect_if_not_admin
    redirect_to root_path unless current_user.has_role? :admin
  end
end
