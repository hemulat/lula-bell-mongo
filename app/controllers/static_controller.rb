class StaticController < ApplicationController
  def home
    @blog=Blog.first
  end

    def admin_home

    end



end
