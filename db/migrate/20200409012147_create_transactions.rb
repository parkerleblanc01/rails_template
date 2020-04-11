class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :symbol
      t.string :description
      t.float :value
      t.float :amount

      t.timestamps
    end
  end
end
