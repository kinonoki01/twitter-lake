class CreateFavoriteUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_users do |t|
      t.string :twitter_account
      t.references :user, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
