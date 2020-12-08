class WeddingDecorator < Draper::Decorator
  delegate_all

  def days_left
    (self.wedding_date - Date.today).to_i
  end

  def days_right
    (Date.today - Date.today).to_i
  end

end
