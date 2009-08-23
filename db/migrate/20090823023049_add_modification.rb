class AddModification < ActiveRecord::Migration
  def self.up
    add_column :events, :modification, :datetime
  end

  def self.down
    remove_column :events, :modification
  end
end
