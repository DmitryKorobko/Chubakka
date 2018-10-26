class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :redirect_to_root, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Chubakka!'

      redirect_to @user
    else
      render 'new'
    end
  end

  def edit; end

  def update
    admin_status = @user.admin?

    if @user.update_attributes(user_params)
      @user.admin = admin_status if @user.admin != admin_status
      @user.save
      flash[:success] = 'Profile Updated'

      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if current_user.id != params[:id]
      User.find(params[:id]).destroy
      flash[:success] = 'User Deleted.'
    else
      flash[:warning] = 'Can Not Delete My Own.'
    end

    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def redirect_to_root
    if signed_in?
      redirect_to root_path
    end
  end
end
