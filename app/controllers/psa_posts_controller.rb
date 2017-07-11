class PsaPostsController < ApplicationController

  before_action :authorize_admin

  def new
    @psa_post = PsaPost.new
  end

  def create
    @psa_post = PsaPost.new(post_params)
    @psa_post.update_attribute(:created_at, DateTime.now)
    @psa_post.save
    redirect_to static_admin_home_path
  end

  private
    def post_params
      params.require(:psa_post).permit(:title, :text, :created_at)
    end

end
