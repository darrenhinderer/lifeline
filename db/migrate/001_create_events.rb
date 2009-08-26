class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.string :content, 	:limit => 500
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :private,	:default => false
    end
  end

  def self.down
    drop_table :events
  end
end
