class CreateAuthorsSeries < ActiveRecord::Migration
  def self.up
    create_table :authors_series do |t|
      t.string :role
      t.references :author
      t.references :serie

      t.timestamps
    end
  end

  def self.down
    drop_table :authors_series
  end
end
