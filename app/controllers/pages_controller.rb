class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @article1 = sample
    @article2 = sample
    @article3 = sample

    if params[:query].present?
      @articles = Article.search_by_title_text_author(params[:query])
    else
      @articles = Article.all
    end
  end

  def dashboard
    @user = current_user
  end
  private

  def sample
    Article.all.sample
  end
end
