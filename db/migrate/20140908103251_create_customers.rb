class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :code
      t.string :name
      t.string :address
      t.string :postcode
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :customers, :code, unique: true
  end
end
