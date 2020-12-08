# encoding: utf-8
class TimetablesController < BaseWeddingController
  before_filter :check_wedding
  before_filter :find_timetable, only: [:edit, :update]

  def index
    timetable = current_wedding.current_timetable
    redirect_to wedding_timetable_event_path(timetable, timetable.last_event_id)
  end

  def show
    timetable = current_wedding.timetables.find_by_id(params[:id]) || current_wedding.current_timetable
    redirect_to wedding_timetable_event_path(timetable, timetable.last_event_id)
  end

  def edit
  end

  def update
    params[:events].each do |event_id, param|
      event = @timetable.events.find(event_id)
      event.update_attributes(param)
    end
    redirect_to wedding_timetable_event_path @timetable, @timetable.last_event_id
  end

  private
  def check_wedding
    if current_client.wedding.blank?
      redirect_to edit_client_path(current_client, anchor: 'wedding-settings'), notice: 'Пожалуйста, создайте свадьбу'
    end
  end

  def find_timetable
    @wedding   = current_wedding
    @timetable = current_wedding.timetables.find(params[:id])
  end
end
