# encoding: utf-8
module Users::ProfilesHelper

  def current_user_role
    current_user.is_performer ? 'Исполнитель' : 'Гость'
  end

  def invite_of_current_user_gender
    current_user.gender ? 'Невесту' : 'Жениха'
  end

  def current_user_gender
    current_client.gender ? 'Жених' : 'Невеста'
  end

  def current_user_couple_gender
    current_client.gender ? 'Невеста' : 'Жених'
  end

  def create_wedding_with
    "Создать свадьбу #{current_user.has_couple? ? current_user.couple.name : ''}"
  end

  def current_user_type
    case current_user.type_user
    when 0
      "Гость"
    when 1
      "Исполнитель"
    when 2
      "Администратор"
    end
  end
end
