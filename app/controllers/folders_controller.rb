class FoldersController < ApplicationController
  before_action :require_user_logged_in
  before_action :find_folder, only: [:show, :edit, :update, :destroy]
  before_action :find_folders, only: [:index, :create]
  
  def index
  end

  def show
    exist_folder
    @favorite_tweets = @folder.favorite_tweets
  end

  def new
    @folder = current_user.folders.new
  end

  def create
    # foldersテーブルの最大positionから保存するpositionを計算
    @folders.any? ? position = current_user.folders.maximum(:position) + 1 : position = 1
    params[:folder][:position] = position
    
    @folder = current_user.folders.new(folder_params)
    if @folder.save
      flash[:success] = 'フォルダを追加しました'
      redirect_to folders_url
    else
      flash.now[:danger] = 'フォルダの追加に失敗しました'
      render :new
    end
  end

  def edit
    exist_folder
  end

  def update
    if @folder.update(folder_params)
      flash[:success] = 'フォルダの名前を更新しました'
      redirect_to folders_url
    else
      flash.now[:danger] = 'フォルダの名前の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @folder.destroy
    flash[:success] = 'フォルダを削除しました'
    redirect_to folders_url
  end
  
  private
  
  def folder_params
    params.require(:folder).permit(:name, :position)
  end
  
  def find_folder
    @folder = current_user.folders.find_by(id: params[:id])
  end
  
  def find_folders
    @folders = current_user.folders.order(position: :asc)
  end
  
  def exist_folder
    if !@folder
      # ログインユーザ以外が作成したフォルダ、もしくは存在しないフォルダを指定した場合
      flash[:success] = '指定したフォルダは存在しません'
      redirect_to root_url
    end
  end
end
