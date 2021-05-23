class CreateBillDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :bill_details do |t|
      t.integer :quantityHD
      t.integer :priceHD
      t.belongs_to :product
      t.belongs_to :bill
      t.timestamps
    end
  end
end
