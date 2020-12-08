# encoding: utf-8
module PlansHelper
  def time_left(timetable)
    if timetable.index_number >= 1 && timetable.index_number <= 7 && timetable.t_type == Plan::DAY
      "осталось #{timetable.index_number} дней "
    elsif timetable.index_number > 0
      "осталось #{timetable.index_number} недель"
    else
      "cвадьба прошла"
    end
  end

  def tasks_for(timetable, prefix='на')
    if timetable.t_type == Plan::WEDDING_DAY
      "#{prefix} день свадьбы"
    elsif timetable.t_type == Plan::PLANNING
      "#{prefix} планирование"
    else
      "#{prefix} #{timetable.index_number} неделю"
    end
  end

  def link_to_service(service)
    link_to service, "#"
  end

  def plan_class plan, plan_current
    plan == plan_current ? 's1' : ''
  end

end
