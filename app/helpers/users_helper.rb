# encoding: utf-8
module UsersHelper
  def marital_status(user, couple)
    if couple
      status = user.male? ? "Помолвлен" : "Помолвлена"
      link = link_to(couple.full_name, user_path(couple))
      "#{status} c #{link}".html_safe
    else
      user.male? ? "Не женат" : "Не замужем"
    end
  end

  def reg_resource_name
    :user
  end

  def reg_client
    @reg_resource ||= ClientRegistrationForm.new
  end

  def reg_firm
    @firm_reg_resource ||= FirmRegistrationForm.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def social_icon(provider, type = nil)
    type = type ? "-#{type}" : ''
    content_tag(:i, nil, class: "icon-#{provider.to_s+ type}")
  end

end
