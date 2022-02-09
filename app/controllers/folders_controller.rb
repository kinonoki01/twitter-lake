class FoldersController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @folders = current_user.folders.order(position: :asc)
  end

  def show
    find_folder
  end

  def new
    @folder = current_user.folders.new
  end

  def create
    @folders = current_user.folders.order(position: :asc) # index表示用

    # positionの最大値を更新    
    position = current_user.folders.maximum(:position) + 1
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
    find_folder
  end

  def update
    find_folder
    
    if @folder.update(folder_params)
      flash[:success] = 'フォルダの名前を更新しました'
      redirect_to folders_url
    else
      flash.now[:danger] = 'フォルダの名前の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    find_folder
    
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
end
