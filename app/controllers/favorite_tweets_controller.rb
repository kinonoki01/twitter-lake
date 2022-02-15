class FavoriteTweetsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @folders = current_user.folders.order(position: :asc) # フォルダ一覧表示用
    @folder = current_user.folders.find_by(id: params[:folder_id])
    
    if !@folder
      # ログインユーザ以外が作成したフォルダ、もしくは存在しないフォルダを指定した場合
      flash[:success] = '指定したフォルダは存在しません'
      redirect_to root_url
    else
      @favorite_tweets = @folder.favorite_tweets.order(position: :asc)
    end
  end

  def show
    @folder = current_user.folders.find_by(id: params[:folder_id])
    if !@folder
      flash[:success] = '指定したフォルダは存在しません'
      redirect_to root_url
    else
      @favorite_tweet = @folder.favorite_tweets.find_by(id: params[:id])
      if !@favorite_tweet
        # ログインユーザ以外が追加したツイート、もしくは存在しないツイートを指定した場合
        flash[:success] = '指定したツイートは存在しません'
        redirect_to folder_favorite_tweets_url(@folder)
      end
    end
  end

  def new
    @folder = current_user.folders.find_by(id: params[:folder_id])
    @favorite_tweet = @folder.favorite_tweets.new
  end

  def create
    @folder = current_user.folders.find_by(id: params[:folder_id])
    
    @folder.favorite_tweets.any? ? position = @folder.favorite_tweets.maximum(:position) + 1 : position = 1
    params[:favorite_tweet][:position] = position
    
    @favorite_tweet = @folder.favorite_tweets.new(favorite_tweet_params)
      
    if @favorite_tweet.save
      flash[:success] = 'ツイートをお気に入りに登録しました'
      redirect_to folder_favorite_tweets_url(@folder)
    else
      flash[:danger] = 'お気に入りの登録に失敗しました'
      render :new
    end
  end

  def edit
    @folder = current_user.folders.find_by(id: params[:folder_id])
    if !@folder
      flash[:success] = '指定したフォルダは存在しません'
      redirect_to root_url
    else
      @favorite_tweet = @folder.favorite_tweets.find_by(id: params[:id])
      if !@favorite_tweet
        # ログインユーザ以外が追加したツイート、もしくは存在しないツイートを指定した場合
        flash[:success] = '指定したツイートは存在しません'
        redirect_to folder_favorite_tweets_url(@folder)
      else
        folders = current_user.folders.order(position: :asc)
        @folder_list = [] # プルダウンリスト表示用
        
        folders.each do |folder|
          @folder_list.push([folder.name, folder.id])
        end
      end
    end
  end

  def update
    @folder = current_user.folders.find_by(id: params[:folder_id])
    @favorite_tweet = @folder.favorite_tweets.find_by(id: params[:id])
    
    if @favorite_tweet.update(favorite_tweet_params)
      flash[:success] = 'お気に入りツイートを移動しました'
      redirect_to folder_favorite_tweets_url(@folder)
    else
      flash.now[:danger] = 'お気に入りツイートの移動に失敗しました'
      render :edit
    end
  end

  def destroy
    @folders = current_user.folders.order(position: :asc) # index表示用
    @folder = current_user.folders.find_by(id: params[:folder_id]) # index選択済みフォルダ判定用
    
    @favorite_tweet = @folder.favorite_tweets.find_by(id: params[:id])
    @favorite_tweet.destroy
    flash[:success] = 'お気に入りから削除しました'
    redirect_to folder_favorite_tweets_url(@folder, @favorite_tweet)
  end
  
  private
  
  def favorite_tweet_params
    params.require(:favorite_tweet).permit(:tweet, :position, :folder_id)
  end
  
  def exist_folder
    
  end
end
