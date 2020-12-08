# encoding: utf-8
module WeddingsHelper
  def groom_and_bride(wedding)
    if current_user.role == 'groom'
      groom = current_user.name
      bride = current_user.couple.name if current_user.has_couple?
      "#{groom} и #{bride}"
    elsif current_user.role == 'bride'
      bride = current_user.name
      groom = current_user.couple.name if current_user.has_couple?
      "#{bride} и #{groom}"
    end

  end

  def progress_bar
    content_tag(:div, class: 'progress  progress-striped') do
      content_tag(:div, '', class: 'bar', style: 'width: 30%')
    end
  end

  def percent_complete wedding
    100 * wedding.events.completed.count / wedding.events.where('type_task <> \'advice\'').count if wedding.events.count > 0
  end

  def timetable_class timetable_select, timetable_current, timetable_other
    case timetable_other
    when timetable_current then 's1'
    when timetable_select then 's2'
    end
  end

  def timetable_name type, index_number
    case type
    when Plan::PLANNING then 'Планирование'
    when Plan::WEEK then "#{index_number} неделя"
    when Plan::DAY then "#{index_number} день"
    when Plan::WEDDING_DAY then 'День свадьбы'
    when Plan::AFTER_WEDDING then 'После свадьбы'
    else 'error'
    end
  end

  def link_title_style
    cookies['sv-scheduler-info-box'] ? 'sv-title-down' : 'sv-title-up'
  end
end
