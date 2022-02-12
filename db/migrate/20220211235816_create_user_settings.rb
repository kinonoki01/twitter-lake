class CreateUserSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :user_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :twitter_account_name

      t.timestamps
    end
  end
end
