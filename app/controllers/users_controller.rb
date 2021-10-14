class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update, :destroy]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:user][:name],
      email: params[:user][:email],
      image_name:"user_image.JPG",
      password: params[:user][:password]
    )
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]

    if @user.save
      session[:user_id]= @user.id
      flash[:notice] = "アカウントを作成しました"
      redirect_to(users_path)
    else
      flash[:notice] = "アカウントの作成に失敗しました"
      render(new_user_path)
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.update(
      name: params[:user][:name],
      image_name: params[:user][:image]
    )
    @user.name = params[:user][:name]
    @user.image_name = "#{@user.id}.jpg"
    image = params[:user][:image]

    if image
      @user.update(image_name: "#{@user.id}.jpg" )
      File.binwrite("public/user_images/#{@user.id}.jpg", image.read)
    end

    if @user.save
      redirect_to(users_path)
      flash[:notice] = "アカウントを編集しました"
    else
      render "/users/edit"
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:notice] = "アカウントを削除しました"
    redirect_to(users_path)
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.authenticate(params[:user][:password])
      session[:user_id]= @user.id
      flash[:notice] = "ログインしました"
      redirect_to(posts_path)
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:user][:email]
      @password = params[:user][:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to(login_path)
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to(posts_path)
    end
  end
end
