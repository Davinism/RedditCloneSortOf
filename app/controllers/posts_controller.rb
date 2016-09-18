class PostsController < ApplicationController
  before_action :check_if_author, only: :edit

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save!
      params[:post][:sub_ids].each do |sub_id|
        PostSub.create!(post_id: @post.id, sub_id: sub_id) unless sub_id == ""
      end
      redirect_to post_url(@post)
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
      @post.subs.each do |post_sb|
        unless params[:post][:sub_ids].include?(post_sb.id)
          PostSub.find_by(sub_id: post_sb.id, post_id: @post.id).destroy
        end

        params[:post][:sub_ids].each do |param_sub_id|
           PostSub.create(post_id: @post.id, sub_id: param_sub_id) unless param_sub_id == ""
        end

      end

      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end


  def check_if_author
    @post = Post.find(params[:id])
    unless current_user.id == @post.user_id
      redirect_to post_url(@post)
    end
  end

  def post_params
    params.require(:post).permit(:title, :url, :content)
  end
end
