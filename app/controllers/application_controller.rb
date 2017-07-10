class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorize_admin
    redirect_to root_path, alert: 'Admins only!' unless admin_signed_in?
  end

end
