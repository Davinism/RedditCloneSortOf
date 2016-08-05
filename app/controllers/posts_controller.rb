class PostsController < ApplicationController
  before_action :check_if_author, only: :edit

  def new

  end

  def create
    @post = Post.new(title: params[:post][:title],
                      url: params[:post][:url],
                      content: params[:post][:content],
                      sub_id: params[:sub_id])
    @post.user_id = current_user.id

    if @post.save!
        redirect_to sub_post_url(id: @post.id)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find_by_id(params[:id])
    render :edit
  end

  def destroy
    @post = Post.find_by_id(params[:id])
    subtopic = Sub.find_by_id(@post.sub_id)
    if @post.destroy
      redirect_to sub_url(subtopic)
    else
      flash.now[:errors] = @post.errors.full_messages
      redirect_to sub_url(subtopic)
    end
  end

  def show
    @post = Post.find_by_id(params[:id])
    render :show
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to sub_post_url(id: @post.id)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end


  def check_if_author
    @post = Post.find(params[:id])
    unless current_user.id == @post.user_id
      redirect_to sub_post_url(id: @post.id)
    end
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end
end
