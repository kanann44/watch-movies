class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}


  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: @post.user_id)
  end

  def new
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to(login_path)
    end
    @post = Post.new
  end

  def create
    @post = Post.new(
      comment: params[:post][:comment],
      title: params[:post][:title],
      score: params[:post][:score],
      movie_image: params[:post][:image],
      user_id: @current_user.id
    )
    @post.comment = params[:post][:comment]
    @post.title = params[:post][:title]
    @post.movie_image = "#{@post.id}.jpg"
    image = params[:post][:image]

    if @post.save
      if image
        File.binwrite("public/posts_images/#{@post.id}.jpg", image.read)
        @post.update(movie_image: "#{@post.id}.jpg" )
      else
        @post.update(image_name: "default_post.png" )
      end
      redirect_to(posts_path)
      flash[:notice] = '投稿に成功しました'
    else
      flash[:notice] = '投稿に失敗しました'
      render(new_post_path)
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.update(
      comment: params[:post][:comment],
      title: params[:post][:title],
      score: params[:post][:score],
      movie_image: params[:post][:image]
    )
    @post.comment = params[:post][:comment]
    @post.title = params[:post][:title]
    @post.score = params[:post][:score]
    @post.movie_image = "#{@post.id}.jpg"
    image = params[:post][:image]

    if image
      @post.update(movie_image: "#{@post.id}.jpg" )
      File.binwrite("public/posts_images/#{@post.id}.jpg", image.read)
    end

    if @post.save
      flash[:notice] = '投稿を更新しました'
      redirect_to(posts_path)
    else
      flash[:notice] = '投稿の更新に失敗しました'
      render "/posts/edit"
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    if @post.destroy
      flash[:notice] = '投稿に削除しました'
      redirect_to(posts_path)
    else
      flash[:notice] = '投稿に削除できませんでした'
      redirect_to(posts_path)
    end
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to(posts_path)
    end
  end
end
