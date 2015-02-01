class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.belongs_to :user, index: true
      t.belongs_to :customer, index: true
      t.date :date
      t.integer :precedence
      t.datetime :complete
      t.integer :travel_time

      t.timestamps
    end
  end
end
