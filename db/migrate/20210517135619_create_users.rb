class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :usernameUS
      t.string :passwordUS
      t.string :email
      t.string :imgUS

      t.timestamps
    end
  end
end
