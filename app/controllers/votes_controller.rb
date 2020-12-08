# encoding: utf-8
class VotesController < ApplicationController
  respond_to :js

  def like
    @resource = eval(params[:resource_class_name]).find(params[:resource])
    @resource_class_name = params[:resource_class_name]
    current_user.likes @resource
    respond_with(@resource)
  end

  def unlike
    @resource = eval(params[:resource_class_name]).find(params[:resource])
    @resource_class_name = params[:resource_class_name]
    current_user.dislikes @resource
    respond_with(@resource)
  end
end
