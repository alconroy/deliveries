class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.belongs_to :user, index: true
      t.float :latitude
      t.float :longitude
      t.datetime :time

      t.timestamps
    end
  end
end
