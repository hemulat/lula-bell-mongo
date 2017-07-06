class BlogsController < ApplicationController
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

        if @blog.update(post_params)
          redirect_to posts_path
        end
    end

    def destroy
      @blog = Blog.find(params[:id])
      @blog.destroy
      redirect_to blogs_path, notice: "#{@blog.title} has been deleted!" and return
    end

    private
      def blog_params
        params.require(:blog).permit(:title, :content, :created_at, :image)
      end


end
