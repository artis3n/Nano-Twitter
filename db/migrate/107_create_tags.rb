class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :users
  end
end
