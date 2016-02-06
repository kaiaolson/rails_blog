class HomeController < ApplicationController
  def index
  end
  def about
  end
  def search
    @term = params[:q]
    @results = Post.search(@term)
  end
end
