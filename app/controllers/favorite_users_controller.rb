class FavoriteUsersController < ApplicationController
  before_action :require_user_logged_in
  before_action :find_favorite_users, only: [:index, :show, :create]
  
  def index
  end

  def show
    @favorite_user = current_user.favorite_users.find_by(id: params[:id])
  end

  def new
    @favorite_user = current_user.favorite_users.new
  end

  def create
    # favorite_usersテーブルの最大positionから保存するpositionを計算
    current_user.favorite_users.maximum(:position).nil? ? position = 1 : position = current_user.favorite_users.maximum(:position) + 1
    params[:favorite_user][:position] = position

    @favorite_user = current_user.favorite_users.new(favorite_user_params)
    if @favorite_user.save
      flash[:success] = 'ユーザーを追加しました'
      redirect_to favorite_user_url(@favorite_user)
    else
      flash.now[:danger] = 'ユーザーの追加に失敗しました'
      render :new
    end
  end

  def destroy
    @favorite_user = current_user.favorite_users.find_by(params[:id])
    @favorite_user.destroy
    flash[:success] = 'ユーザーを削除しました'
    redirect_to favorite_users_url
  end
  
  private
  
  def favorite_user_params
    params.require(:favorite_user).permit(:twitter_account, :position)
  end
  
  def find_favorite_users
    @favorite_users = current_user.favorite_users.order(position: :asc)
  end
end
