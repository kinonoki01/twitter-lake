class CreateFolders < ActiveRecord::Migration[6.1]
  def change
    create_table :folders do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
