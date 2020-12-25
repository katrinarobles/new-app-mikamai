class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @article1 = Article.all.sample
    @article2 = Article.all.sample
    if params[:query].present?
      @articles = Article.search_by_title_text_author(params[:query])
    else
      @articles = Article.all
    end
  end

  def dashboard
    @user = current_user
  end
end
