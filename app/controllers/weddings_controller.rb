# encoding: utf-8
class WeddingsController < BaseWeddingController
  respond_to :json, :html

  def create
    params[:wedding_date] = params[:wedding_date].to_date

    if params[:create_type] == 'edit_date' && params[:without_date].blank?
      script = Script.select_script(params[:wedding_date], current_wedding.start_date)
      current_wedding.update_attributes(script_id: script.id, wedding_date: params[:wedding_date])
    elsif params[:create_type] == 'new_date' || params[:without_date].present?
      current_wedding.destroy if current_client.has_wedding?
      if params[:without_date].present?
        script = Script.order(:weeks).last
        params[:wedding_date] = Date.today + (script.weeks + 1).week
      else
        script = Script.select_script(params[:wedding_date].to_date, Date.today)
      end
      current_client.create_wedding(script_id: script.id, start_date: Date.today, wedding_date: params[:wedding_date])
      current_client.save
      if current_client.has_couple?
        current_client.couple.wedding = current_wedding
        current_client.couple.save
      end
    end
    respond_to do |format|
      format.json { render json: { status: 'success' } }
      format.html { redirect_to wedding_path }
    end
  end

  def change_couple
    couple = Client.find(params[:couple_id])
    if current_client.betrothed_to? couple
      current_client.couple.break_couple
      current_client.couple.copy_wedding(current_wedding) if current_client.has_wedding?
      current_client.couple = nil
      current_client.save
    elsif current_client.not_invited? couple
      current_client.create_invite couple
    end
    redirect_to edit_client_path(current_client, anchor: 'wedding-settings')
  end

  def invite_couple
    invite = params[:invite]
    if valid_email?(invite[:email])
      resource = current_client.invite_couple(invite[:firstname], invite[:lastname], invite[:email])
      if current_client.has_couple?
        current_client.couple.break_couple
        current_client.couple.copy_wedding(current_wedding) if current_client.has_wedding?
      end
      current_client.create_couple_with resource
    end
    redirect_to edit_client_path(current_client, anchor: 'wedding-settings')
  end

  def change_avatar
    @wedding = current_user.wedding
    if @wedding.update_attributes(avatar: params[:wedding][:avatar])
      render json: {avatar: @wedding.avatar.thumb.url}
    else
      render json: {status: @wedding.errors}
    end
  end

  private
  def valid_email?(email)
    email.present? && (email =~ /@/i) && User.where(email: email).empty?
  end
end
