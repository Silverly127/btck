class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.integer :check
      t.datetime :datecheck
      t.string :address
      t.belongs_to :administrator
      t.belongs_to :user
      t.timestamps
    end
  end
end
