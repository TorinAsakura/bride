# encoding: utf-8
class Idea::BaseController < ApplicationController
  respond_to :html
  skip_before_filter :authenticate_user!
  before_filter :set_instance_variables

  protected
  def set_instance_variables
    @all_sections = ::Idea::Section.ordered.includes(:categories).uniq
  end
end