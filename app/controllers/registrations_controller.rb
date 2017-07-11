class RegistrationsController < Devise::RegistrationsController

  before_action :authorize_admin, only: [:new, :create]
  skip_before_action :require_no_authentication, only: [:new, :create]

  def new
    super
  end

  def create
    @admin = Admin.new(sign_up_params)
    if @admin.save
      redirect_to static_admin_home_path, notice: 'Account successfully created!'
    else
      redirect_to static_admin_home_path, alert: 'An error occurred while creating the account.'
    end
  end

  private
    def sign_up_params
      params.require(:admin).permit(:email, :password, :password_confirmaiton, :superadmin)
    end

    def authorize_admin
      redirect_to root_path, alert: 'You do not have the permissions to perform this action.' unless admin_signed_in? && current_admin.superadmin
    end

end
