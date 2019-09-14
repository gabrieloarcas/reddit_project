class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  respond_to :js, :json, :html

  # before_action :set_post, except: [:index, :new, :create]

  def index
    # @posts = Post.all.order(created_at: :desc)

  if params[:category].blank?
    @posts = Post.all.order("created_at DESC")
    else
    @category_id = Category.find_by(name: params[:category]).id
    @posts = Post.where(category_id: @category_id).order("created_at DESC")
    end


  end

  def show
    @relative_posts = @post.category.posts
  end

  def new
    @post = current_user.posts.create
  end

  def create
    @post = current_user.posts.create(post_params)
    if @post.save
      flash[:success] = "The post was created!"
    redirect_to @post
    else 
      render 'new'
    end
  end

  def edit
  end

  def update
    @post.update(post_params)
    redirect_to @post
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  def upvote
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    redirect_to @post #Updating the vote without reloading....... 
  end
    
  def downvote
    @post = Post.find(params[:id])
    @post.downvote_by current_user
    redirect_to @post
  end

  private

    def post_params
      params.require(:post).permit(:title, :body, :category_id)
    end

    def set_post
      @post = Post.find(params[:id])
    end

end
  

