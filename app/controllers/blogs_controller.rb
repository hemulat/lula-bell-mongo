class BlogsController < ApplicationController

  before_action :authorize_admin, except: :index
    def index
      @blogs=Blog.all
    end

    def new
      @blog=Blog.new
    end

    def create
      @blog = Blog.new(blog_params)

     if @blog.save
       redirect_to blogs_path, notice: "The blog has been created!" and return
     end
     render 'new'
    end

    def edit
        @blog = Blog.find(params[:id])
    end

    def update
        @blog = Blog.find(params[:id])

        if @blog.update(blog_params)
          redirect_to blogs_path
        end
    end

    def destroy
      @blog = Blog.find(params[:id])
      @blog.destroy
      redirect_to blogs_path, notice: "#{@blog.title} has been deleted!" and return
    end

    private
      def blog_params
        params.require(:blog).permit(:title, :content, :created_at, :image, :url)
      end


end
