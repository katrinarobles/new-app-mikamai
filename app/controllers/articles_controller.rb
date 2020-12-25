class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = policy_scope(Article)
  end

  def show
    console
  end

  def new
    @article = Article.new
    authorize @article
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    authorize @article
    if @article.save
      redirect_to @article, notice: 'Shared successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Shared successfully!'
    else
      render :edit
    end
  end

  def destroy
  end

  private
  def article_params
    params.require(:article).permit(:title, :text, :user_id, :photo)
  end

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end
end
