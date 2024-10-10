class CreateInstallments < ActiveRecord::Migration[7.1]
  def change
    create_table :installments do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.decimal :amount_due, null: false
      t.decimal :amount_paid, default: 0, null: false
      t.string :status, default: 'pending', null: false

      t.timestamps
    end
  end
end
