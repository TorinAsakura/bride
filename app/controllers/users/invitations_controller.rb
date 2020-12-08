# encoding: utf-8
class Users::InvitationsController < Devise::InvitationsController
  #TODO some owerrides
  # https://github.com/scambra/devise_invitable

  def create
    user_attrs = params[:user]

    existed = user_attrs.delete(:existed)

    if existed.eql?('0') && user_attrs[:email].blank?
      current_client.couple_id = 0
      current_client.save
    else

      if existed.eql?('0')
        client = Client.create(:firstname => user_attrs[:name], :gender => !current_client.gender, :couple_id => current_client.id)
        user = User.invite!({:email => user_attrs[:email], :profileable_type => 'Client', :profileable_id => client.id, :read=>true}, current_user)
        unless client.errors.empty? && user.errors.empty?
          user.destroy
          redirect_to root_path, alert: "Ошибка создания: проверьте e-mail"
          return
        end
        self.resource = client
      elsif existed.eql?('1')
        self.resource = current_client
        self.resource = Client.no_couple.find(params[:couple_id])
      end
      unless resource.errors.empty?
        render :action => 'new', :layout => false
        return
      end
      current_client.desctroy_couple
      current_client.make_wedding(resource)
      resource.make_wedding(current_client)
      #resource.add_to_wedding(current_user) unless current_user.wedding_id.nil?
    end

    redirect_to root_path
  end
end
