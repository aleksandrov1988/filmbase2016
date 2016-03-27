class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.string :name
      t.string :origin_name
      t.string :slogan
      t.belongs_to :country, index: true, foreign_key: true
      t.belongs_to :genre, index: true, foreign_key: true
      t.belongs_to :director, index: true, foreign_key: true
      t.integer :length
      t.integer :year
      t.string :trailer_url
      t.attachment :cover
      t.text :description

      t.timestamps null: false
    end
  end
end
