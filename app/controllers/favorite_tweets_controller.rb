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
    # 入力値から埋め込み用HTMLを作成
    begin
      create_uri(params[:favorite_tweet][:tweet])
    rescue Exception => e
      flash.now[:warning] = '入力したURLが間違っています'
      puts e.message
      puts e.backtrace.inspect
    end
    params[:favorite_tweet][:tweet] = @oembed_tweet
    
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
    edit_folder = params[:favorite_tweet][:edit_folder]
    params[:favorite_tweet].delete("edit_folder")
    
    if edit_folder == 'move'
      # お気に入りツイートのフォルダ移動の場合
      @folder = current_user.folders.find_by(id: params[:folder_id])
      @favorite_tweet = @folder.favorite_tweets.find_by(id: params[:id])
      
      if @favorite_tweet.update(favorite_tweet_params)
        flash[:success] = 'お気に入りツイートを移動しました'
        redirect_to folder_favorite_tweets_url(@folder)
      else
        flash.now[:danger] = 'お気に入りツイートの移動に失敗しました'
        render :edit
      end
    else
      # お気に入りツイートのコピーの場合、保存するパラメータを設定
      orginal_folder = current_user.folders.find_by(id: params[:folder_id])
      original_favorite_tweet = orginal_folder.favorite_tweets.find_by(id: params[:id])
      params[:favorite_tweet][:tweet] = original_favorite_tweet.tweet
      
      # コピー先のpositionを取得
      @folder = current_user.folders.find_by(id: params[:favorite_tweet][:folder_id])
      @folder.favorite_tweets.any? ? position = @folder.favorite_tweets.maximum(:position) + 1 : position = 1
      params[:favorite_tweet][:position] = position
      
      @favorite_tweet = @folder.favorite_tweets.new(favorite_tweet_params)
      
      if @favorite_tweet.save
        flash[:success] = "ツイートを#{@folder.name}フォルダにコピーしました。"
        redirect_to folder_favorite_tweets_url(@folder)
      else
        folders = current_user.folders.order(position: :asc)
        @folder_list = [] # プルダウンリスト表示用
        
        folders.each do |folder|
          @folder_list.push([folder.name, folder.id])
        end
        
        flash.now[:danger] = 'ツイートのコピーに失敗しました'
        render :edit
      end
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
  
  # 入力されたURLから埋め込みHTMLを作成
  def create_uri(tweet)
    tweet_id = tweet.match(/\/status\/(.*)/)[1]
    if tweet_id.include?("status")
      # アカウントIDがstatusであるユーザの場合の追加処理
      tweet_id = tweet_id.match(/status\/(.*)/)[1]
    end
    url = "https://publish.twitter.com/oembed?url=https%3A%2F%2Ftwitter.com%2FInterior%2Fstatus%2F#{tweet_id}"

    json_response = JSON.parse(OpenURI.open_uri(url).read)
    @oembed_tweet = json_response['html']
  end
end
