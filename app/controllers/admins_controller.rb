class AdminsController < ApplicationController

  before_action :authorize_admin

  def index
    @admins = Admin.all
  end

  def destroy
    @admin = Admin.find(params[:id])
    if @admin.destroy
      redirect_to root_path, notice: 'Account successfully deleted!'
    else
      redirect_to admins_path, alert: 'The account could not be deleted.'
    end
  end
end
