class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :group_id
      t.integer :location_id
      t.time :start_time
      t.time :end_time
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
