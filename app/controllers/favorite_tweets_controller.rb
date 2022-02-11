class FavoriteTweetsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @folders = current_user.folders.order(position: :asc) # フォルダ一覧表示用
    @folder = current_user.folders.find_by(id: params[:id])
    @favorite_tweets = @folder.favorite_tweets.order(position: :asc)
  end

  def show
    puts params
    @folder = current_user.folders.find_by(id: params[:id])
    @favorite_tweet = @folder.favorite_tweets.find_by(id: params[:id])
  end

  def new
    @folder = current_user.folders.find_by(id: params[:id])
    @favorite_tweet = @folder.favorite_tweets.new
  end

  def create
    @folder = current_user.folders.find_by(id: params[:id])
    
    @folder.favorite_tweets.any? ? position = @folder.favorite_tweets.maximum(:position) + 1 : position = 1
    params[:favorite_tweet][:position] = position
    
    @favorite_tweet = @folder.favorite_tweets.new(favorite_tweet_params)
    if @favorite_tweet.save
      flash[:success] = 'ツイートをお気に入りに登録しました'
      redirect_to favorite_tweets_url(@folder)
    else
      flash[:danger] = 'お気に入りの登録に失敗しました'
      render :new
    end
  end

  def edit
    @folder = current_user.folders.find_by(id: params[:id])
    @favorite_tweet = @folder.favorite_tweets.find_by(params[:id])
    folders = current_user.folders.order(position: :asc)
    @folder_list = [] # プルダウンリスト表示用
    
    folders.each do |folder|
      @folder_list.push([folder.name, folder.id])
    end
  end

  def update
    puts params[:favorite_tweet][:folder_id]
    puts params[:favorite_tweet][:edit_folder]
    
  end

  def destroy
    @folders = current_user.folders.order(position: :asc) # index表示用
    @folder = current_user.folders.find_by(params:[id]) # index選択済みフォルダ判定用
    
    @favorite_tweet = @folder.favorite_tweets.find_by(params[:id])
    @favorite_tweet.destroy
    flash[:success] = 'お気に入りから削除しました'
    redirect_to favorite_tweet_url(@folder, @favorite_tweet)
  end
  
  private
  
  def favorite_tweet_params
    params.require(:favorite_tweet).permit(:tweet, :position)
  end
end
