class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :origin_name
      t.date :birthday
      t.attachment :avatar

      t.timestamps null: false
    end
  end
end
