class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user_setting = @user.build_user_setting # ユーザ設定を空で作成しておく
    if @user.save && @user_setting.save
      flash[:success] = 'Signupしました'
      session[:user_id] = @user.id
      redirect_to root_url
    else
      flash.now[:danger] = 'Signupに失敗しました'
      render :new
    end
  end

  def edit
    @user_setting = current_user.user_setting
  end

  def update
    @user_setting = current_user.user_setting
    
    if current_user.update(user_params) && @user_setting.update(user_setting_params)
      flash[:success] = 'ユーザー設定を更新しました'
      redirect_to user_edit_url(current_user)
    else
      flash[:danger] = 'ユーザー設定の更新に失敗しました'
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def user_setting_params
    params.require(:user_setting).permit(:twitter_account_name)
  end
end
