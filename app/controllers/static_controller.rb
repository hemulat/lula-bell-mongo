class StaticController < ApplicationController

  before_action :authorize_admin, only: [:admin_home]

  def home
  end

  def admin_home
  end

end
