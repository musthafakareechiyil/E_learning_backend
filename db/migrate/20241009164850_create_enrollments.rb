class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :number_of_installments, null: false
      t.string :status, default: 'active'

      t.timestamps
    end

    add_index :enrollments, [:user_id, :course_id], unique: true
  end
end
