class CreateAdministrators < ActiveRecord::Migration[6.1]
  def change
    create_table :administrators do |t|
      t.string :usernameAD
      t.string :passwordAD
      t.string :imgAD

      t.timestamps
    end
  end
end
