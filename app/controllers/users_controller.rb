class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :edit, :update]
  
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Signupしました'
      redirect_to root_url
    else
      flash.now[:danger] = 'Signupに失敗しました'
      render :new
    end
  end

  def edit
  end

  def update
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
