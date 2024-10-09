class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :photo

      t.timestamps
    end
  end
end
