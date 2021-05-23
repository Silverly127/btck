class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      t.integer :idSP
      t.string :tenSP
      t.integer :slSP
      t.integer :tonkho
      t.integer :giaSP
      t.integer :giamSP
      t.timestamps
    end
  end
end
