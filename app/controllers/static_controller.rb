class StaticController < ApplicationController

  before_action :authorize_admin, only: [:admin_home]

  def home
    @psa_posts = PsaPost.order_by(:created_at => 'desc')
  end

  def admin_home
  end

end
