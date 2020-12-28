class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  def index
    @articles = policy_scope(Article)
    @articles = Article.joins(:user).search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])
  end

  def show
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
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to dashboard_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :text, :user_id, :photo, :url)
  end

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  def sort_column
    Article.joins(:user).column_names.include?(params[:sort]) ? params[:sort] : "title"
    # Article.joins(:user).column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
