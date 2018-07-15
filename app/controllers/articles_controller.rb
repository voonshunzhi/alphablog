class ArticlesController < ApplicationController
	before_action :set_article, only:[:edit,:update,:destroy,:show]
	before_action :require_user,except:[:index,:show]
	before_action :require_same_user,only:[:update,:edit,:destroy]
	
	def index
		@articles = Article.paginate(page:params[:page],per_page:5)
	end
	def show
	end
	def new
		@article = Article.new
	end
	def create
		#You just create the object here
		@article = Article.new(article_params)
		@article.user = current_user
		if @article.save
			flash[:success] = "Article is successfully added!"
			redirect_to articles_path(@article)
		else
			render 'new'
		end
	end
	def edit
	end
	def update
		if @article.update_attributes(article_params)
			flash[:success] = "Article is successfully updated!"
			redirect_to articles_path(@article)
		else
			render 'edit'
		end
	end
	def destroy
		if @article.delete
			flash[:success] = "Article is successfully deleted!"
		else
			flash[:danger] = "Delete unsuccessful!"
		end
		redirect_to articles_path
	end
	private
	def set_article
		@article = Article.find(params[:id])
	end
	def article_params
		params.require(:article).permit(:title, :description)
	end
	def require_same_user
		if current_user != @article.user && !current_user.admin?
			flash[:danger] = "You can only edit your own article"
			redirect_to root_path
		end
	end
	
end
