class Admin::UserAdminsController < AdminController
  layout 'admin_application'
  before_filter :find_user, only: [:make, :remove]

  def index
    @clients = Client.all
    @firms = Firm.all
  end

  def make
    @user.add_role :admin 
    redirect_to admin_user_admins_path
  end

  def remove
    @user.admin_roles.destroy_all
    redirect_to admin_user_admins_path
  end

  private 
  def find_user
    @user = User.find(params[:id])
  end
end
