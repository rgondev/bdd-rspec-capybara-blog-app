class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:edit, :update, :show, :destroy]

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = "Article has been created"
      redirect_to articles_path
    else
      flash.now[:danger] = "Article has not been created"
      render :new
    end
  end

  def edit
    if @article.user != current_user
      flash[:danger] = "You can only edit your own article"
      redirect_to root_path
    end
  end

  def update
    if @article.user != current_user
      flash[:danger] = "You can only edit your own article"
      redirect_to root_path
    else
      if @article.update_attributes(article_params)
        flash[:success] = "Article has been updated"
        redirect_to article_path(@article)
      else
        flash.now[:danger] = "Article has not been updated"
        render :new
      end
    end
  end

  def show
    @comment = @article.comments.build
  end

  def destroy
    if @article.destroy
      flash[:success] = "Article has been deleted"
      redirect_to articles_path
    end
  end

  private def article_params
    params.require(:article).permit(:title, :body)
  end

  private def set_article
    @article = Article.find(params[:id])
  end
end
