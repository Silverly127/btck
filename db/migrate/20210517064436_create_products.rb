class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :nameSP
      t.integer :quantitySP
      t.integer :priceSP
      t.integer :discount
      t.string :imgSP
      t.belongs_to :category
      t.timestamps
    end
  end
end
