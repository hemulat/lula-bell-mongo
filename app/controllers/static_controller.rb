class StaticController < ApplicationController

  before_action :authorize_admin, only: [:admin_home]

  def home
    @blogs = Blog.order_by(:created_at => 'desc').limit(5)
    @psa_posts = PsaPost.order_by(:created_at => 'desc').limit(20)
  end

  def admin_home
  end

end
