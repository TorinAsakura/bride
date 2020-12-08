# encoding: utf-8
class ProgrammsController < ApplicationController

  before_filter :define_site, except: :index
  respond_to :js, :html

  def edit_program
    if params[:second_day]
      @programs = @site.programms.second_day
    else
      @programs = @site.programms.wedding_day
    end
  end

  def index
    @site = (params[:site_id]).present? ? Site.find(params[:site_id]) : Site.find_by_name(request.subdomain(Subdomain.position))

    if params[:second_day]
      @programs = @site.programms.second_day
    else
      @programs = @site.programms.wedding_day
    end
  end

  def new
    @event_programm = Programm.new second_day: params[:second_day]
    respond_with(@event_programm) do |format|
      format.js{ render layout: false }
    end
  end

  def create
    @event_programm = Programm.new(params[:programm])
    @event_programm.site = @site
    @event_programm.client = current_client
    @event_programm.second_day = params[:second_day]

    respond_to do |format|
      if @event_programm.save
        format.html { redirect_to :back }
        format.json { render json: @event_programm, status: :created, location: edit_path(@site, params[:second_day]) }
      else
        format.html { redirect_to :back }
        format.json { render json: @event_programm.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @event_programm = @site.programms.find(params[:id])
  end

  def update
    @event_programm = @site.programms.find(params[:id])
    @event_programm.update_attributes(params[:programm])
    redirect_to :back
  end

  def destroy
   @event_programm = @site.programms.find(params[:id])
   @event_programm.destroy
   redirect_to :back
  end

  private
  def define_site
    @site = current_client.site
  end

  def edit_path site, second_day
    # true в кавычках потому что в параметрах приходит строка
    'true' == second_day || true == second_day ? site_edit_second_day_program_path(site) : site_edit_wedding_program_path(site)
  end
end
