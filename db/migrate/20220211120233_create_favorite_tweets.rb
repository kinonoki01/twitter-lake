class CreateFavoriteTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_tweets do |t|
      t.text :tweet
      t.references :folder, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
