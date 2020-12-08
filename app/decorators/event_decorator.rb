class EventDecorator < Draper::Decorator
  delegate_all

  def type_id
    if self.completed?
      5
    elsif self.user_event?
      6
    else
      case type_task.to_s
      when Event::SIMPLY then 2
      when Event::WITH_SERVICE then 3
      when Event::ADVICE then 4
      else 0
      end
    end
  end
end
