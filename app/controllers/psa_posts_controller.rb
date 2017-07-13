class PsaPostsController < ApplicationController

  before_action :authorize_admin

  def index
    @psa_posts = PsaPost.order_by(:created_at => 'desc')
  end

  def new
    @psa_post = PsaPost.new
  end

  def create
    @psa_post = PsaPost.new(post_params)
    @psa_post.update_attribute(:created_at, DateTime.now)
    @psa_post.save
    redirect_to static_admin_home_path
  end

  def edit
    @psa_post = PsaPost.find(params[:id])
  end

  def update
    @psa_post = PsaPost.find(params[:id])

    if @psa_post.update(post_params)
      redirect_to psa_posts_path, notice: 'The PSA has been updated!'
    else
      redirect_to psa_posts_path, alert: 'Error. The PSA could not be updated!'
    end
  end

  def destroy
    @psa_post = PsaPost.find(params[:id])
    if @psa_post.destroy
      redirect_to psa_posts_path, notice: 'The PSA has been deleted!'
    else
      redirect_to psa_posts_path, alert: 'Error. The PSA could not be deleted.'
    end
  end

  private
    def post_params
      params.require(:psa_post).permit(:title, :text, :created_at)
    end

end
