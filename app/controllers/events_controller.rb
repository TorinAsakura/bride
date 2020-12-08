class EventsController < BaseWeddingController
  before_filter :find_event, except: [:show, :new, :create]
  before_filter :find_timetable, only: [:show, :new, :edit]
  before_filter :set_search_firms_variable, only: [:show, :firms_search]
  respond_to :js, :html

  def show
    @wedding = current_wedding
    @timetables = @wedding.timetables.sort_by(&:index_number).reverse.group_by(&:t_type)
    @events = EventDecorator.decorate_collection(@timetable.events.order_by_position)
    @clients_on_current_timetable = Client.on_current_timetable @timetable
    @event = @wedding.events.includes(:task).find_by_id(params[:id])

    @search = FirmSearch.new(params[:search])
  end

  def edit
  end

  def update
    @event.update_attributes(params[:event])
    redirect_to wedding_timetable_event_path @event.timetable, @event
  end

  def new
    @event = @timetable.events.new
  end

  def create
    @timetable = current_wedding.timetables.find(params[:event][:timetable_id])
    event = @timetable.events.create(params[:event].merge(task_category_id: 0,
                                                    type_task: Task::SIMPLY,
                                                    date_to: @timetable.events.first.date_to))
    current_wedding.events << event
    redirect_to wedding_timetable_event_path @timetable, event
  end

  def destroy
    status = @event.user_event? && @event.destroy ? 'ok' : 'error'
    render json: { status: status }
  end

  def change_status
    case params[:status]
    when 'hide' then @event.hide! unless @event.advice?
    when 'complete' then @event.complete! if @event.may_complete?
    when 'uncomplete', 'unhide' then @event.uncomplete! if @event.may_uncomplete?
    end
    render json: { status: @event.aasm_state }
  end

  def ideas
    per_count = params[:show] == 'all' ? EVENT_COUNT_IDEAS_PAGE : EVENT_COUNT_IDEAS
    @ideas = @event.task.ideas.includes(:image).page(params[:ideas_page]).per(per_count)
  end

  def posts
    per_count = params[:show] == 'all' ? EVENT_COUNT_POSTS_PAGE : EVENT_COUNT_POSTS
    @posts = Post.includes(:journal).without_communities.accepted.get_paginate(@event, params[:posts_page], per_count)
  end

  def video
    per_count = params[:show] == 'all' ? EVENT_COUNT_VIDEO_PAGE : EVENT_COUNT_VIDEO
    @video = MediaContent.accepted.get_paginate(@event, params[:video_page], per_count)
  end

  def firms_search
    if @event && @event.have_firms?
      params[:search].merge!(firm_catalog_ids: @event.task.firm_catalog_ids.join(','))
      search_firm = FirmSearch.new(params[:search])
      search_t_firm = TFirmSearch.new(params[:search])
      firms_res = search_firm.results.catalog_ordered
      t_firms_res = search_t_firm.results

      firms = firms_res + t_firms_res.uniq_by(&:name)
      firms = Kaminari.paginate_array(firms).page(params[:page]).per(EVENT_COUNT_FIRMS)
      @firms = FirmsDecorator.decorate_collection(firms)
    end
  end

  def subevent_status
    @event.change_subevent_checkbox(params[:subevent_id], params[:status_id])
    render json: { status: 'success' }
  end

  private
  def find_event
    @event = current_wedding.events.find(params[:id])
  end

  def find_timetable
    begin
      @timetable = current_wedding.timetables.find(params[:timetable_id])
    rescue
      redirect_to wedding_path
    end
  end

  def set_search_firms_variable
      params[:search] = Hash.new unless params.has_key? :search 
      params[:search].merge!(city_id: current_client.wedding_city.id) unless params[:search].has_key? :city_id
  end
end
