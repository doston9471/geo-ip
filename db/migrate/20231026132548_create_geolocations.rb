class CreateGeolocations < ActiveRecord::Migration[7.1]
  def change
    create_table :geolocations do |t|
      t.string :ip, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end
    add_index :geolocations, :ip
  end
end
